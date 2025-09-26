class InterfaceCache
  def self.get_cache(model_class)
    raise NotImplementedError
  end
  def fetch(id, &block)
    raise NotImplementedError
  end
  def store(record)
    raise NotImplementedError
  end
  def remove(id)
    raise NotImplementedError
  end
  def clear_all!
    raise NotImplementedError
  end
end