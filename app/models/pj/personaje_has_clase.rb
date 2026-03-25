class Pj::PersonajeHasClase < ApplicationRecord
  #attributes: nivel
  belongs_to :personaje
  belongs_to :clase
  has_many :personajeHasHabilidads, as: :hasHabilidads, dependent: :destroy, autosave: true
  has_many :calculados, as: :hasCalculados, class_name: "Pj::Calculado", dependent: :destroy, autosave: true, inverse_of: :hasCalculados

  has_rich_text :sobreescritura
end
