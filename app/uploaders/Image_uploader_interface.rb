class ImageUploaderInterface

  # @return nil if not found otherwise returns an object that responds to #id, #data, #nombre, #content_type and #url
  def get(id)
    raise NotImplementedError, "Subclasses must implement the get method"
  end

  # @param file an object that responds to #read, #original_filename and optionally #content_type
  # @return the created image objct that responds to #id, #data, #nombre, #content_type and #url
  def add(file)
    raise NotImplementedError, "Subclasses must implement the add method"
  end

  # @param record an object that responds to #id
  def remove!(record)
    raise NotImplementedError, "Subclasses must implement the remove! method"
  end

  def clear_all!
    raise NotImplementedError, "Subclasses must implement the clear_all! method"
  end
end