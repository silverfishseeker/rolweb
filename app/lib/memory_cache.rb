class MemoryCache < InterfaceCache
  
  private(:initialize)
  def initialize(model_class)
    size = ImageUploaderConfig.memory_size.megabytes
    @memory_cache = ActiveSupport::Cache::MemoryStore.new(size: size)
    @model_class = model_class.to_s
  end

  def self.get_cache(model_class)
    MemoryCache.new(model_class)
  end

  def fetch(id)
    if block_given?
      @memory_cache.fetch(id) do
        yield
      end
    else
      @memory_cache.read(id)
    end
  end

  def store(record)
    raise 'MemoryCache.store: record cannot be nil' unless record
    @memory_cache.write(record.id, record)
  end

  def remove(id)
    @memory_cache.delete(id)
  end

  def clear_all!
    @memory_cache.clear
  end
end