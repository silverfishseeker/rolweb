class Habilidad < ApplicationRecord
    has_and_belongs_to_many :clases
    has_and_belongs_to_many :items
    mount_uploader :image, ImageUploader
end
