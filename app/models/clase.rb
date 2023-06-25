class Clase < ApplicationRecord
    has_and_belongs_to_many :habilidads
    mount_uploader :image, ImageUploader
end
