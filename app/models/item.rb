class Item < ApplicationRecord
    has_and_belongs_to_many :clases
    mount_uploader :image, ImageUploader
end
