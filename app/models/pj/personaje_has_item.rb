class Pj::PersonajeHasItem < ApplicationRecord
  #attributes: cantidad, sobreescritura
  belongs_to :personaje
  belongs_to :item
  
  has_rich_text :sobreescritura

    scope :ordered, -> { joins(:item).order("items.nombre") }
end
