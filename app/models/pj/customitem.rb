class Pj::Customitem < ApplicationRecord
  belongs_to :personaje_has_item, class_name: "Pj::PersonajeHasItem"
end
