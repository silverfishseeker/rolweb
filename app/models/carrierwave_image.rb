class CarrierwaveImage < ApplicationRecord
    # atributes: nombre, file, content_type
    mount_uploader :file, ImageUploader
end
