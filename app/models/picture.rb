class Picture < ApplicationRecord
    # atributes: nombre, image
    mount_image_uploader

    has_and_belongs_to_many :etiquets
    has_many :personajes
end
