class Personaje < ApplicationRecord
  # attributes: nombre, descripcion
  belongs_to :user
  belongs_to :picture
  has_rich_text :descripcion
end
