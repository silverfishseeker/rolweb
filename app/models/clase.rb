class Clase < ApplicationRecord
    has_and_belongs_to_many :habilidads
    has_and_belongs_to_many :items
    mount_uploader :image, ImageUploader
end
