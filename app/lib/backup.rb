require 'fileutils'
require 'json'
require 'zlib'
require 'minitar'

module Backup

  # Excluimos images también. No queremos descargarlas por duplicado en el caso de que se use DatabaseimageUploader
  DATA_TABLES = ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata", "images"]
  BACKUPS_DIR = Rails.root.join("tmp", "backups")
  FileUtils.mkdir_p(BACKUPS_DIR) unless Dir.exist?(BACKUPS_DIR)
  

  def self.time_now
    Time.current.strftime("%Y-%m-%d_%H-%M-%S")
  end
  
  def self.images_dir(dir)
    images_path = dir.join("images")
    FileUtils.mkdir_p(images_path) unless Dir.exist?(images_path)
    images_path
  end
  


  def self.silence_sql
    original_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = Logger.new(IO::NULL)
    yield
  ensure
    ActiveRecord::Base.logger = original_logger
  end



  # Create a backup of the database and Minio images
  def self.prepare_backup_files(temp_dir)
    Rails.logger.info "🔧 Preparing backup files in #{temp_dir}"
    FileUtils.mkdir_p(temp_dir)

    Rails.logger.info "💾 Dumping database..."
    data = (DATA_TABLES).map do |table|
      [table, ActiveRecord::Base.connection.select_all("SELECT * FROM #{table}").to_a]
    end.to_h
    File.write(temp_dir.join("database.json"), JSON.generate(data))

    Rails.logger.info "📋 Dumping database schema..."
    schema = DATA_TABLES.to_h do |table|
      [table, ActiveRecord::Base.connection.columns(table).map(&:name).sort]
    end
    File.write(temp_dir.join("schema.json"), JSON.pretty_generate(schema))
    
    Rails.logger.info "🖼️ Dumping images from models..."
    imgdir = Backup.images_dir(temp_dir)

    # It is necessary to ensure the models are loaded to get all descendants of ActiveRecord::Base
    Rails.application.eager_load! unless Rails.configuration.eager_load
    ActiveRecord::Base.descendants.each do |model|
      next unless model.respond_to?(:has_image_uploader)
      model_imgdir = imgdir.join(model.name)
      FileUtils.mkdir_p(model_imgdir)
      metadata = []
      model.find_each do |record|
        img = record.image
        next unless img
        File.binwrite(model_imgdir.join(record.id.to_s), img.data)
        metadata << {
          id: record.id,
          original_filename: img.nombre,
          content_type: img.content_type || "application/octet-stream"
        }
      end
      File.write(model_imgdir.join("images_meta.json"), JSON.pretty_generate(metadata))
    end

    Rails.logger.info "✅ Images downloaded."
  end



  def self.create
    Rails.logger.info "🚀 Starting backup process..."
    backup_name = "backup_#{time_now}"
    temp_dir = BACKUPS_DIR.join(backup_name)
    backup_path = BACKUPS_DIR.join("#{backup_name}.tar.gz")

    begin
      prepare_backup_files(temp_dir)

      Rails.logger.info "📦 Packing backup files into #{backup_path} from #{temp_dir}..."
      Zlib::GzipWriter.open(backup_path) do |gz|
        Dir.chdir(temp_dir) do
          Minitar.pack(Dir["*"], gz)
        end
      end
      Rails.logger.info "✅ Backup created :D"
      backup_path
    ensure
      FileUtils.rm_rf(temp_dir)
    end
  end


  require "active_record/fixtures"
  def self.brave_restore(restore_dir)

    Rails.logger.info "🧹 Deleting database..."
    ActiveRecord::Base.transaction do
      DATA_TABLES.each do |table|
        ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
      end
    end

    Rails.logger.info "💽 Restoring database data..."
    data = JSON.parse(File.read(restore_dir.join("database.json")))
    data.each do |table, records|
      next unless DATA_TABLES.include?(table)
      expected_columns = ActiveRecord::Base.connection.columns(table).map(&:name)
      records.each do |record|
        filtered_record = record.slice(*expected_columns)
        ActiveRecord::Base.connection.insert_fixture(filtered_record, table)
      end
    end

    Rails.logger.info "🗑️ Deleting images..."
    uploader = ImageUploaderConfig.uploader
    uploader.clear_all!

    Rails.logger.info "📷 Restoring images..."
    imgdir = images_dir(restore_dir)
    temp_path = imgdir.join("uploading_image")
    imgdir.children.each do |model_dir|
      model = model_dir.basename.to_s.safe_constantize
      metadata = JSON.parse(File.read(model_dir.join("images_meta.json")))
      SilverImageUploader.warn_on_remove_missing = false
      metadata.each do |entry|
        id = entry["id"]
        
        file_path = model_dir.join(id.to_s)
        if entry["content_type"] == "image/gif"
          FileUtils.cp(file_path, temp_path)
        else
          system("convert #{file_path} -strip #{temp_path}")
        end

        record = model.find(id)
        File.open(temp_path) do |f|
          record.image = ActionDispatch::Http::UploadedFile.new(
            filename: entry["original_filename"],
            type: entry["content_type"],
            tempfile: f
          )
          record.save!
        end
      end
      SilverImageUploader.warn_on_remove_missing = true
    end

    Rails.logger.info "🔢 Resetting ID sequences..."
    DATA_TABLES.each do |table|
      pk = ActiveRecord::Base.connection.primary_key(table)
      next unless pk == "id"
      max_id = ActiveRecord::Base.connection.select_value("SELECT MAX(id) FROM #{table}").to_i
      ActiveRecord::Base.connection.execute("SELECT setval('#{table}_#{pk}_seq', #{max_id + 1}, false)")
    end

    Rails.logger.info "✅ Database restore completed."
  end



  class BackupRestoreSchemaMissmatchError < StandardError; end

  def self.restore(file_path, flexible=false, rollback=true)
    Rails.logger.info "📦 Restoring backup from #{file_path} (flexible: #{flexible}) (rollback=#{rollback})"
    restore_id = time_now
    restore_dir = BACKUPS_DIR.join("restore_#{restore_id}")
    FileUtils.mkdir_p(restore_dir)

    Rails.logger.info "📥 Unpacking files"
    Zlib::GzipReader.open(file_path) do |gz|
      Minitar.unpack(gz, restore_dir.to_s)
    end

    Rails.logger.info "🔍 Validating schema (strict mode)..."
    backup_schema = JSON.parse(File.read(restore_dir.join("schema.json")))
    missmatch = check_schema_matches(backup_schema)
    if missmatch and flexible 
      Rails.logger.warn "⚠️ Schema mismatch detected in flexible mode: \n#{missmatch}"
    elsif missmatch and !flexible
      raise BackupRestoreSchemaMissmatchError, "Schema mismatch detected in strict mode: \n#{missmatch}"
    else
      Rails.logger.info "✅ Schema matches."
    end

    if rollback
      Rails.logger.info "📋 Preparing snapshot for rollback..."
      snapshot_path = BACKUPS_DIR.join("snapshot_#{restore_id}")
      silence_sql do
        prepare_backup_files(snapshot_path)
      end
    else
      Rails.logger.info "⚠️ skipping snapshot for rollback."
    end

    begin
      silence_sql do
        Backup.brave_restore(restore_dir)
      end
    rescue => e
      Rails.logger.error "❌ Error during restoration: #{e.message}"
      if rollback
        Rails.logger.error "🔁 Reverting to previous state..."
        silence_sql do
          Backup.brave_restore(snapshot_path)
        end
        Rails.logger.info "✅ Successfully reverted."
      end
      raise e
    ensure
      FileUtils.rm_rf(restore_dir)
      FileUtils.rm_rf(snapshot_path) if rollback
    end
  end



  def self.check_schema_matches(backup_schema)
    current_schema = DATA_TABLES.to_h do |table|
      [table, ActiveRecord::Base.connection.columns(table).map(&:name).sort]
    end

    errors = []

    missing_tables = backup_schema.keys - current_schema.keys
    unless missing_tables.empty?
      errors << "Tables present in the backup but missing in the current DB: #{missing_tables.join(', ')}"
    end
    extra_tables = current_schema.keys - backup_schema.keys
    unless extra_tables.empty?
      errors << "Tables present in the current DB but missing in the backup: #{extra_tables.join(', ')}"
    end

    (backup_schema.keys & current_schema.keys).each do |table|
      expected = backup_schema[table]
      actual = current_schema[table]
      if expected != actual
        missing_cols = expected - actual
        extra_cols = actual - expected

        msg = "Column differences in table '#{table}':"
        msg += " missing in current => [#{missing_cols.join(', ')}]" unless missing_cols.empty?
        msg += " | extra in current => [#{extra_cols.join(', ')}]" unless extra_cols.empty?
        errors << msg
      end
    end

    errors.empty? ? false : errors.join("\n- ")
  end
end