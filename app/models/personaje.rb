class Personaje < ApplicationRecord
  # attributes: nombre, nivel_clases, nivel_habilidades, nivel_estadisticas,
  #   nivel_otro, descripcion, is_public
  has_rich_text :descripcion

  belongs_to :user
  belongs_to :picture

  has_many :estadistics, class_name: "Pj::Estadistic", dependent: :destroy
  has_many :calculados, class_name: "Pj::Calculado", dependent: :destroy
  has_many :rangos, class_name: "Pj::Rangos", dependent: :destroy
  has_many :parteCuerpos, class_name: "Pj::ParteCuerpo", dependent: :destroy
  has_many :hasEstadoalterados, class_name: "Pj::HasEstadoalterado", dependent: :destroy
  has_many :personajeHasClases, class_name: "Pj::PersonajeHasClase", dependent: :destroy
  has_many :personajeHasHabilidads, class_name: "Pj::PersonajeHasHabilidad", dependent: :destroy #habilidades independientes
  has_many :PersonajeHasItem, class_name: "Pj::PersonajeHasItem", dependent: :destroy

  has_and_belongs_to_many :etiquets
  has_and_belongs_to_many :cuentos
  has_and_belongs_to_many :viewUsers, class_name: "User", join_table: "personajes_users"

  def nivel
    nivel_clases.to_i + nivel_estadisticas.to_i + nivel_habilidades.to_i + nivel_otro.to_i # to_i transforma los nil en 0
  end
end
