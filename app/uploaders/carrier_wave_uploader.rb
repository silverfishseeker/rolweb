require "carrierwave"

class CarrierWaveImageUploader
  def get(id)
    cw_image = CarrierwaveImage.find(id: id)
    SilverImage.new(
      id: cw_image.id,
      data: File.binread(cw_image.file.path),
      nombre: cw_image.nombre,
      content_type: cw_image.content_type
    )
  end

  def add(file)
    cw_image = CarrierwaveImage.create!(
      nombre: file.original_filename,
      content_type: file.content_type,
      file: file
    )
    SilverImage.new(
      id: cw_image.id,
      data: cw_image.file.read,
      nombre: cw_image.nombre,
      content_type: cw_image.content_type
    )
  end

  def remove!(record)
    CarrierwaveImage.find_by(id: record.id)&.destroy
  end
end