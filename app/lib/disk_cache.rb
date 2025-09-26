require "fileutils"
require "stringio"

class DiskCache < InterfaceCache
  CACHE_DIR = Rails.root.join('tmp', 'cache', 'hybrid_cache')
  FileUtils.mkdir_p(CACHE_DIR) unless Dir.exist?(CACHE_DIR)
  @@caches = {}

  private(:initialize)
  def initialize(model_class)
    @model_class = model_class
    @disk_cache_path = CACHE_DIR.join(model_class.name.underscore)
    FileUtils.mkdir_p(@disk_cache_path) unless Dir.exist?(@disk_cache_path)
    @@caches[model_class] = self
  end

  def self.get_cache(model_class)
    @@caches.fetch(model_class, DiskCache.new(model_class))
    # nótese que cuando falla, no añade el segundo argumento al hash,
    # pero lo estamos añadiendo en el initialize
  end
  
  def disk_cache_file(id)
    @disk_cache_path.join("#{id}.cache")
  end

  def fetch(id)
    cache_path = disk_cache_file(id)
    if File.exist?(cache_path)
      Marshal.load(StringIO.new(File.read(cache_path)).read)
    else
      # Si se pasa un bloque, se usa para buscar el valor del registro,
      record = yield if block_given?
      return nil unless record
      store(record)
      record
    end
  end

  # stores only in cache, not in database
  def store(record)
    raise 'DiskCache.store: record cannot be nil' unless record
    File.open(disk_cache_file(record.id), 'wb') do |f|
      f.write(Marshal.dump(record))
    end
  end

  def remove(id)
    FileUtils.rm_f(disk_cache_file(id))
  end

  def self.clear_disk_cache!
    Dir.glob("#{CACHE_DIR}/*/*").each do |file|
      FileUtils.rm_f(file)
    end
    Rails.logger.info "DiskCache#clear_disk_cache!: Disk cache cleared completely, subdirectories preserved."
  end
end
