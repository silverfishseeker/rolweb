class Habilidad < ApplicationRecord
    has_and_belongs_to_many :clases
    has_and_belongs_to_many :items
    has_and_belongs_to_many :categs
    has_and_belongs_to_many :mobs
    mount_uploader :image, ImageUploader

    default_scope { where(oculto: false) }
end
