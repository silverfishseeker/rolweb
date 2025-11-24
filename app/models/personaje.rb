class Personaje < ApplicationRecord
  # attributes: nombre, descripcion
  belongs_to :user
  has_rich_text :descripcion
end
