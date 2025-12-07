class Pj::PersonajeHasClase < ApplicationRecord
  #attributes: nivel
  belongs_to :personaje
  belongs_to :clase
  has_many :personajeHasHabilidads, dependent: :destroy

  has_rich_text :sobreescritura
end
