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

  def build_personaje_has_habilidad(personaje, clase)
    Pj::PersonajeHasHabilidad.new(habilidad: self, personaje: personaje, clase: clase, sobreescritura: nil)
  end

  def tipoImagen
    ["red-triangle.png",    # 0, activa
     "blue-circle.png",     # 1, pasiva
     "orange-diamond.png",  # 2, especial
     "purple-triangle.png", # 3, complemento
     "green-square.png",    # 4, creacion
     "yellow-triangle.png", # 5, instantaneo
     "white-square.png"     # 6, sin clasificar
    ][tipo]
  end
end
