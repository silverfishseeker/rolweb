require 'fileutils'
require 'json'
require 'zlib'
require 'minitar'

module Backup

  # Excluimos images también. No queremos descargarlas por duplicado en el caso de que se use DatabaseimageUploader
  # (fíjate que les estamos quitando las tablas de la lista con la resta de arrays)
  DATA_TABLES = ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata", "images", "restore_states"]
  BACKUPS_DIR = Rails.root.join("tmp", "backups")
  SPACE_NAMES = ["Pj", "Ritual"]
  FileUtils.mkdir_p(BACKUPS_DIR) unless Dir.exist?(BACKUPS_DIR)



  def self.eager_load
    # It is necessary to ensure the models are loaded to get all descendants of ActiveRecord::Base
    Rails.application.eager_load! unless Rails.configuration.eager_load
  end

  def self.time_now
    Time.current.strftime("%Y-%m-%d_%H-%M-%S")
  end
  
  def self.images_dir(dir)
    images_path = dir.join("images")
    FileUtils.mkdir_p(images_path) unless Dir.exist?(images_path)
    images_path
  end

  def self.images_ids_map_file(dir)
    dir.join("images_ids_map.json")
  end

  def self.silence_sql
    original_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = Logger.new(IO::NULL)
    yield
  ensure
    ActiveRecord::Base.logger = original_logger
  end


  def self.recursive_self_level(levels, records_by_id, model, column, record, visiting=Set.new)
    return levels[record.id] if levels.key?(record.id)
    if visiting.include?(record.id)
      raise "Circular self dependency in #{model} for id #{record.id}"
    end
    visiting.add(record.id)
    parent_id = record.public_send(column)
    level =
      if parent_id.nil? || (parent = records_by_id[parent_id]).nil?
        0
      else
        recursive_self_level(levels, records_by_id, model, column, parent, visiting) + 1
      end
    visiting.delete(record.id)
    levels[record.id] = level
  end

  def self.fix_classify(name)
    SPACE_NAMES.each do |space_name|
      if name.start_with? space_name
        name.sub! space_name, space_name+"::" 
      end
    end
    name
  end

  def self.compute_self_level(table)
    model = fix_classify(table.classify).constantize
    fk = ActiveRecord::Base.connection.foreign_keys(table).find { |f| f.to_table == table }
    records_by_id = model.all.index_by(&:id)
    model.find_each.each_with_object({}) do |record, levels|
      recursive_self_level(levels, records_by_id, model, fk.column, record)
    end
  end

  def self.compute_level(levels, dependencies, table, visiting=Set.new)
    return levels[table] if levels.key?(table)
    deps = dependencies[table]
    if visiting.include?(table)
      raise "Circular dependency detected involving #{table}, visited: #{visiting}"
    end
    visiting << table
    levels[table] =
      if deps.empty?
        0
      else
        deps.map do |dep|
          compute_level(levels, dependencies, dep, visiting) 
        end.max + 1
      end
    visiting.delete(table)
    levels[table]
  end

  # Create a backup of the database and Minio images
  def self.prepare_backup_files(temp_dir, skip_images=false)
    Rails.logger.info "🔧 Preparing backup files in #{temp_dir}"
    FileUtils.rm_rf(temp_dir) if Dir.exist?(temp_dir)
    FileUtils.mkdir_p(temp_dir)

    Rails.logger.info "💾 Dumping database..."
    data = (DATA_TABLES).map do |table|
      [table, ActiveRecord::Base.connection.select_all("SELECT * FROM #{table}").to_a]
    end.to_h
    File.write(temp_dir.join("database.json"), JSON.pretty_generate(data))

    Rails.logger.info "📋 Dumping database schema..."
    schema = DATA_TABLES.to_h do |table|
      [table, ActiveRecord::Base.connection.columns(table).map(&:name).sort]
    end
    File.write(temp_dir.join("schema.json"), JSON.pretty_generate(schema))

    Rails.logger.info "🕸️ Dumping database dependencies..."
    dependencies = DATA_TABLES.each_with_object({}) do |table, dependencies|
      dependencies[table] = ActiveRecord::Base.connection.foreign_keys(table)
          .map(&:to_table).uniq.select { |t| DATA_TABLES.include?(t) }
    end
    dependencies_copy = {}
    self_levels = dependencies.each_with_object({}) do |(table, deps), self_levels|
      dependencies_copy[table] = deps - [table]
      if deps.include?(table)
        self_levels[table] = compute_self_level(table)
      end
    end
    dependencies = dependencies_copy
    File.write(temp_dir.join("levels.json"), JSON.pretty_generate(
      DATA_TABLES.each_with_object({}) do |table, levels|
        compute_level(levels, dependencies, table)
      end.to_h do |table, level|
        [table, {
          level: level,
          self_levels:  self_levels[table],
          dependencies: dependencies[table]
        }]
      end
    ))
    
    eager_load

    if skip_images
      Rails.logger.info "🖼️ Preparing images ids map file..."
      references  = {}
      ActiveRecord::Base.descendants.each do |model|
        next unless model.respond_to?(:has_image_uploader)
        refs_model = {}
        model.find_each do |record|
          refs_model[record.id] = record.read_attribute(:image)
        end
        references[model.name] = refs_model
      end
      File.write(Backup.images_ids_map_file(temp_dir), JSON.pretty_generate(references))

    else
      Rails.logger.info "🖼️ Dumping images from models..."
      imgdir = Backup.images_dir(temp_dir)
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
  end



  def self.create(skip_images)
    Rails.logger.info "🚀 Starting backup process..."
    backup_name = "backup_#{time_now}#{skip_images ? "_no_imgs" : "_full"}"
    temp_dir = BACKUPS_DIR.join(backup_name)
    backup_path = BACKUPS_DIR.join("#{backup_name}.tar.gz")

    begin
      prepare_backup_files(temp_dir, skip_images=skip_images)

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


  def self.can_resume
    RestoreState.get != nil
  end

  def self.sql_in_replication_role
    ActiveRecord::Base.connection.execute("SET session_replication_role = 'replica';")
    yield
  ensure
    ActiveRecord::Base.connection.execute("SET session_replication_role = 'origin';")
  end

  require "active_record/fixtures"
  def self.brave_restore(restore_dir, allow_missing_imgs, skip_gifs, max_file_size_mb, gc, is_rollback: false)
    images_ids_map_file = Backup.images_ids_map_file(restore_dir)

    if !is_rollback && RestoreState.get
      Rails.logger.info "⏭️ Restore state detected, skipping DB deletion, BD restoring and images deletion..."
    else
      Rails.logger.info "🧹 Deleting database..."
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute("TRUNCATE #{DATA_TABLES.join(', ')} RESTART IDENTITY CASCADE")
      end

      Rails.logger.info "💽 Restoring database data..."
      eager_load
      data = JSON.parse(File.read(restore_dir.join("database.json")))
      levels = JSON.parse(File.read(restore_dir.join("levels.json")))
      levels.sort_by{ |_, vals| vals["level"]}.each do |table, vals|
        next unless DATA_TABLES.include?(table)
        records = data[table]
        records.sort_by { |r| vals["self_levels"][r["id"]]} if vals["self_levels"]
        expected_columns = ActiveRecord::Base.connection.columns(table).map(&:name)
        records.each do |record|
          ActiveRecord::Base.connection.insert_fixture(record.slice(*expected_columns), table)
        end
      end

      if !images_ids_map_file.exist?
        Rails.logger.info "🗑️ Deleting images..."
        SilverImageUploader.clear_all!
      end
    end

    if images_ids_map_file.exist?
      Rails.logger.info "🖼️ Restoring images from ids map file..."
      JSON.parse(File.read(images_ids_map_file)).each do |model_name, refs|
        model = model_name.safe_constantize
        refs.each do |record_id, image_id|
          model.find(record_id).update_column(:image, image_id)
        end
      end

    else
      Rails.logger.info "📷 Restoring images..."
      resume_state_index = RestoreState.get || 0
      restore_index = 0

      if max_file_size_mb
        max_file_size_mb = max_file_size_mb.to_f
        Rails.logger.info "Using max size: #{max_file_size_mb}MB"
      end

      imgdir = images_dir(restore_dir)
      temp_path = imgdir.join("uploading_image")

      imgdir.children.each do |model_dir|
        next unless model_dir.directory?
        Rails.logger.info "  Model_dir: #{model_dir}"
        model = model_dir.basename.to_s.safe_constantize
        records = model.all.index_by(&:id)
        metadata = JSON.parse(File.read(model_dir.join("images_meta.json")))
        SilverImageUploader.warn_on_remove_missing = false
        metadata.each do |entry|
          GC.start if gc

          restore_index+=1
          
          if restore_index <= resume_state_index
            Rails.logger.info "    Skipping entry: index(#{restore_index}) id(#{entry["id"]})"
            next
          end
          
          Rails.logger.info "    Entry: index(#{restore_index}) id(#{entry["id"]})"

          begin
            id = entry["id"]
            file_path = model_dir.join(id.to_s)

            if max_file_size_mb 
              file_size_mb = File.size(file_path).to_f / (1024 * 1024)
              if file_size_mb > max_file_size_mb
                Rails.logger.warn "      Skipping, size #{file_size_mb.round(2)}MB"
                next
              end
            end

            if entry["content_type"] == "image/gif"
              Rails.logger.info "    It is GIF"
              if skip_gifs
                Rails.logger.warn "      Entry: id(#{entry["id"]}) is a gif, skipping because skip_gifs=#{skip_gifs}"
                next
              end
              FileUtils.cp(file_path, temp_path)
            else
              system("convert #{file_path} -strip #{temp_path}")
            end

            record = records[id]
            File.open(temp_path) do |f|
              record.image = ActionDispatch::Http::UploadedFile.new(
                filename: entry["original_filename"],
                type: entry["content_type"],
                tempfile: f
              )
              record.save!
            end

            RestoreState.set restore_index
            Rails.logger.info "    RestoreState saved, index: #{restore_index}"
          rescue => e
            backtrace = allow_missing_imgs ? "\n#{e.backtrace.join("\n")}" : ""
            Rails.logger.error "    Error uploading. Sikipping. id(#{entry["id"]}) filename(#{entry["original_filename"]}) Error: #{e.message} #{backtrace}"
            unless allow_missing_imgs
              SilverImageUploader.warn_on_remove_missing = true
              raise e
            end
            restore_index+=1
          end
        end
        SilverImageUploader.warn_on_remove_missing = true
        RestoreState.set nil
      end
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




  def self.restore(file_path, resume=false, flexible=false, rollback=true, allow_missing_imgs=false, skip_gifs=false, max_file_size_mb=false, gc=false)
    Rails.logger.info "📦 Restoring backup from #{file_path} (flexible: #{flexible}) (rollback=#{rollback}) (allow_missing_imgs=#{allow_missing_imgs}) (skip_gifs=#{skip_gifs}) (max_file_size_mb=#{max_file_size_mb})"
    reset_backup_dir
    restore_dir = BACKUPS_DIR.join("restore_#{time_now}")
    FileUtils.mkdir_p(restore_dir)

    Rails.logger.info "📥 Unpacking files"
    Zlib::GzipReader.open(file_path) do |gz|
      Minitar.unpack(gz, restore_dir.to_s)
    end
    if resume
      Rails.logger.info "⏯️ Resuming restore from index #{RestoreState.get}"
    else
      RestoreState.set nil
      Rails.logger.info "🔍 Validating schema (strict mode)..."
      backup_schema = JSON.parse(File.read(restore_dir.join("schema.json")))
      missmatch = check_schema_matches(backup_schema)
      if missmatch and flexible 
        Rails.logger.warn "⚠️ Schema mismatch detected in flexible mode: \n#{missmatch}"
      elsif missmatch and !flexible
        raise "Schema mismatch detected in strict mode: \n#{missmatch}"
      else
        Rails.logger.info "✅ Schema matches."
      end

      if rollback
        Rails.logger.info "📋 Preparing snapshot for rollback..."
        snapshot_path = BACKUPS_DIR.join("snapshot")
        silence_sql do
          prepare_backup_files(snapshot_path)
        end
      else
        Rails.logger.info "⚠️ skipping snapshot for rollback."
      end
    end

    begin
      silence_sql do
        Backup.brave_restore(restore_dir, allow_missing_imgs, skip_gifs, max_file_size_mb, gc)
      end
    rescue => e
      Rails.logger.error "❌ Error during restoration: #{e.message}\n#{e.backtrace.join("\n")}"
      if rollback
        Rails.logger.error "🔁 Reverting to previous state..."
        silence_sql do
          Backup.brave_restore(snapshot_path, false, false, false, false, is_rollback: true)
        end
        Rails.logger.info "✅ Successfully reverted."
      end
      raise e
    end
    reset_backup_dir
  end

  def self.reset_backup_dir
    Rails.logger.info "🧹 Cleaning all backup files..."
    FileUtils.rm_rf(BACKUPS_DIR)
    FileUtils.mkdir_p(BACKUPS_DIR)
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