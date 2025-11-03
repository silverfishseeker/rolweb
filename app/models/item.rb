class Item < ApplicationRecord
    # atributes: nombre, coste, peso, efecto, image
    has_rich_text :efecto

    mount_image_uploader

    remove_attribute_if_checked :image

    has_and_belongs_to_many :clases
    has_and_belongs_to_many :habilidads
    has_and_belongs_to_many :mobs
    has_and_belongs_to_many :categs
    has_and_belongs_to_many :contextoloots

    has_one :ritual, class_name: 'Ritual::Ritual', foreign_key: 'item_id', dependent: :destroy
    accepts_nested_attributes_for :ritual, allow_destroy: true
    def es_ritual; ritual.present? end # virtual attribute
    def es_ritual=(_value) end # we do nothing on set
end
