class Clase < ApplicationRecord
    has_and_belongs_to_many :habilidades
    mount_uploader :image, ImageUploader
end
