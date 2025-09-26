class DatabaseImageUploader
  
  # @return nil if not found
  def get(id)
    Image.find_by(id: id)
  end

  def add(file)
    Image.create!(
        data: file.read,
        nombre: file.original_filename)
  end

  def remove!(record)
    record.destroy
  end

  def clear_all!
    Image.delete_all
  end
end
