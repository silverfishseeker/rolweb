class LocalImageUploader < ImageUploaderInterface

  STORAGE_PATH = Rails.root.join('public', 'uploads', 'images')

  def file_path(id)
    STORAGE_PATH.join(id.to_s)
  end

  def meta_path(id)
    STORAGE_PATH.join("#{id}.json")
  end

  def initialize
    FileUtils.mkdir_p(STORAGE_PATH) unless Dir.exist?(STORAGE_PATH)
  end

  def get(id)
    file_path  = file_path(id)
    meta_path  = meta_path(id)
    return nil unless File.exist?(file_path) && File.exist?(meta_path)
    meta = JSON.parse(File.read(meta_path))
    SilverImage.new(
      id: id,
      data: File.binread(file_path),
      nombre: meta['nombre'],
      content_type: meta['content_type']
    )
  end

  def add(file)
    id = SecureRandom.uuid
    file_path = file_path(id)

    File.binwrite(file_path, file.read)

    File.write(meta_path(id), JSON.generate({
      nombre: file.original_filename,
      content_type: file.content_type
    }))

    SilverImage.new(
      id: id,
      data: File.binread(file_path),
      nombre: file.original_filename,
      content_type: file.content_type
    )
  end

  def remove!(record)
    id = record.id.to_s
    File.delete(file_path(id))
    File.delete(meta_path(id))
  end

  def clear_all!
    FileUtils.rm_rf(STORAGE_PATH)
    FileUtils.mkdir_p(STORAGE_PATH)
  end
end