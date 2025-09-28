# Modelo con los datos binario de la imágenes para DatabaseImageUploader

class Image < ApplicationRecord
  # atributes: nombre, data
  include ImageUrlable

  def content_type
    ext = File.extname(nombre).delete(".").downcase
    mime_type = MIME::Types.type_for(ext).first
    mime_type ? mime_type.content_type : "application/octet-stream"
  end
end