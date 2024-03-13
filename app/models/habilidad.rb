class Habilidad < ApplicationRecord
    has_and_belongs_to_many :clases
    has_and_belongs_to_many :items
    has_and_belongs_to_many :categs
    has_and_belongs_to_many :mobs
    has_and_belongs_to_many :mobsHasHabil, class_name: 'Mob', join_table: 'mobsHasHabil'
    mount_uploader :image, ImageUploader

    scope :hide, ->(secreto=false) { where(oculto: secreto) }
end
