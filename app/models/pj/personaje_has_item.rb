class Pj::PersonajeHasItem < ApplicationRecord
  #attributes: cantidad, sobreescritura, position
  belongs_to :personaje
  belongs_to :item
  
  has_many :calculados, as: :hasCalculados, class_name: "Pj::Calculado", dependent: :destroy, autosave: true, inverse_of: :hasCalculados
  
  has_rich_text :sobreescritura

  scope :ordered, -> { joins(:item).order("items.nombre") }
end
