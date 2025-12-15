class Personaje < ApplicationRecord
  # attributes: nombre, nivel_clases, nivel_habilidades, nivel_estadisticas,
  #   nivel_otro, descripcion, is_public
  has_rich_text :descripcion

  belongs_to :user
  belongs_to :picture

  has_many :estadistics,
    -> { joins(:tipoEstadistic).order("pj_meta_tipos.orden ASC") },
    class_name: "Pj::Estadistic",
    dependent: :destroy, autosave: true
  has_many :calculados, class_name: "Pj::Calculado", dependent: :destroy
  has_many :parteCuerpos, class_name: "Pj::ParteCuerpo", dependent: :destroy
  has_many :hasEstadoalterados, class_name: "Pj::HasEstadoalterado", dependent: :destroy
  has_many :personajeHasClases, class_name: "Pj::PersonajeHasClase", dependent: :destroy
  has_many :personajeHasHabilidads, class_name: "Pj::PersonajeHasHabilidad", dependent: :destroy #habilidades independientes
  has_many :PersonajeHasItem, class_name: "Pj::PersonajeHasItem", dependent: :destroy

  has_and_belongs_to_many :etiquets
  has_and_belongs_to_many :cuentos
  has_and_belongs_to_many :viewUsers, class_name: "User", join_table: "personajes_users"

  def nivel
    sum_nil nivel_clases, nivel_estadisticas, nivel_habilidades, nivel_otro # sum_nil ignora nils
  end
end
