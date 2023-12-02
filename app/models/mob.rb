class Mob < ApplicationRecord
    has_and_belongs_to_many :items
    has_and_belongs_to_many :habilidads
    mount_uploader :image, ImageUploader
end
