# Uso exclusivo para sevir la fuente de imágenes

class ImagesController < ActionController::Base

  @@image_uploader ||= SilverImageUploader.new

  # Acción para servir el archivo binario como imagen descargable
  def download
    image = @@image_uploader.get(params[:id])
    send_data image.data,
        filename: image.nombre,
        type: image.content_type,
        disposition: "inline"
  end
end