class Mob < ApplicationRecord
    # atributes: nombre, descripcion, cuerpo, image, estabilidad, armaduraMagica, penetracionFisica, penetracionMagica, sangre, oro
    has_rich_text :descripcion
    has_rich_text :cuerpo
    
    mount_image_uploader

    has_many :mob_has_items, dependent: :destroy
    accepts_nested_attributes_for :mob_has_items, allow_destroy: true

    has_and_belongs_to_many :habilidads
    has_and_belongs_to_many :habilidadsOfMob, class_name: "Habilidad", join_table: 'mobs_has_habils'
end
