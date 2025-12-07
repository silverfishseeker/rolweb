class Personaje < ApplicationRecord
  # attributes: nombre, descripcion
  has_rich_text :descripcion

  belongs_to :user
  belongs_to :picture

  has_many :estadistics, dependent: :destroy
  has_many :calculados, dependent: :destroy
  has_many :rangos, dependent: :destroy
  has_many :parteCuerpos, dependent: :destroy
  has_many :hasEstadoAlterados, dependent: :destroy
  has_many :personajeHasClases, dependent: :destroy
  has_many :personajeHasHabilidads, dependent: :destroy #habilidades independientes
  has_many :PersonajeHasItem, dependent: :destroy

  has_and_belongs_to_many :etiquets
  has_and_belongs_to_many :cuentos
  has_and_belongs_to_many :viewUsers, class_name: "User", join_table: "personajes_users"
end
