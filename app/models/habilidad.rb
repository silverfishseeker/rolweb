class Habilidad < ApplicationRecord
  # atributes: nombre, nivel, efecto, oculto, tipo
  has_rich_text :efecto

  mount_image_uploader
  remove_attribute_if_checked :image

  has_and_belongs_to_many :clases
  has_and_belongs_to_many :items
  has_and_belongs_to_many :categs
  has_and_belongs_to_many :mobs

  scope :hide, ->(secreto=false) { where(oculto: secreto) }

  def build_personaje_has_habilidad(personaje)
    Pj::PersonajeHasHabilidad.new(habilidad: self, hasHabilidads: personaje, sobreescritura: nil)
  end

  def tipoImagen
    ["red-triangle.png", 
     "blue-circle.png", 
     "orange-diamond.png",
     "purple-triangle.png",
     "green-square.png",
     "yellow-triangle.png",
     "white-square.png"
    ][tipo]
  end
end
