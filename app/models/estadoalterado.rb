class Estadoalterado < ApplicationRecord
  # atributes: nombre, descripcion, isNumeric
  has_rich_text :descripcion
end
