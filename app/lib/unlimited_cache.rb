module UnlimitedCache
  EXPIRES = 1.week
  
  @@memory_cache ||= ActiveSupport::Cache::MemoryStore.new

  def cache_set key, value
    @@memory_cache.write(key, value, expires_in: EXPIRES)
  end

  def cache_fetch key
    @@memory_cache.fetch(key, expires_in: EXPIRES) do
      yield if block_given?
    end
  end

  def cache_delete key
    @@memory_cache.delete(key)
  end

  def cache_clear
    @@memory_cache.clear
  end
end