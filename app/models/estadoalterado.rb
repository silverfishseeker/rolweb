class Estadoalterado < ApplicationRecord
  # atributes: nombre, descripcion, isNumeric
  has_rich_text :descripcion

  def fullName
    nombre + (isNumeric ? " X" : "")
  end
end
