class Item < ApplicationRecord
    has_and_belongs_to_many :clases
    has_and_belongs_to_many :habilidads
    has_and_belongs_to_many :mobs
    mount_uploader :image, ImageUploader
end
