class Pj::PersonajeHasHabilidad < ApplicationRecord
  belongs_to :hasHabilidads, polymorphic: true
  belongs_to :habilidad

  has_many :calculados, as: :hasCalculados, class_name: "Pj::Calculado", dependent: :destroy, autosave: true, inverse_of: :hasCalculados

  has_rich_text :sobreescritura
end
