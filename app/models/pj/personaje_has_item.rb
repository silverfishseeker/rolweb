class Pj::PersonajeHasItem < ApplicationRecord
  belongs_to :personaje
  belongs_to :Item
  
  has_rich_text :sobreescritura
end
