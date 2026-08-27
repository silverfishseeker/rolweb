require "active_support/cache"

class HybridCache

  @@caches = {}

  private(:initialize)
  def initialize(model_class)
    @memory_cache = MemoryCache.get_cache(model_class)
    @disk_cache = DiskCache.get_cache(model_class)
  end

  # Asgurar una interfaz identica a DiskCache
  def self.get_cache(model_class) 
    @@caches[model_class] ||= HybridCache.new(model_class)
  end

  # fetches from memory cache first, then from disk cache if not found in memory
  # if a block is given, it will be used to fetch the record if not found in either cache
  # if a block is not given, it will try to find the record in the database
  def fetch(id)
    @memory_cache.fetch(id) do
      @disk_cache.fetch(id) do
        block_given? ? yield : nil
      end
    end
  end

  # stores only in cache, not in database
  def store(record)
    raise 'HybridCache.store: record cannot be nil' unless record
    @memory_cache.store(record)
    @disk_cache.store(record)
  end

  def remove(id)
    @memory_cache.remove(id)
    @disk_cache.remove(id)
  end

  def clear_all!
    @memory_cache.clear_all!
    @disk_cache.clear_all!
  end
end
