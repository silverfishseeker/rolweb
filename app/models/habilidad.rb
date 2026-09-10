class Habilidad < ApplicationRecord
  # atributes: nombre, nivel, efecto, oculto, tipo
  has_rich_text :efecto

  mount_image_uploader
  remove_attribute_if_checked :image

  has_and_belongs_to_many :clases
  has_and_belongs_to_many :items
  has_and_belongs_to_many :categs
  has_and_belongs_to_many :mobs
  has_many :personajeHasHabilidads, class_name: "Pj::PersonajeHasHabilidad"

  scope :hide, ->(secreto=false) { where(oculto: secreto) }

  after_update if: :saved_change_to_tipo? do
    new_list = Pj::PersonajeHasHabilidad::TIPO_TO_LIST.fetch(tipo)
    personajeHasHabilidads.find_each do |phh|
      ordenado = phh.ordenados.first
      next if ordenado.list.to_sym == new_list
      min = Pj::Ordenado.where(personaje_id: phh.personaje_id, list: new_list).minimum(:position) || 0
      ordenado.update!(list: new_list, position: min - 1)
    end
  end

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
