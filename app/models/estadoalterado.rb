class Estadoalterado < ApplicationRecord
  # atributes: nombre, descripcion, isNumeric
  has_rich_text :descripcion

  # clase del target
  AMBITOS = [nil, "Personaje", "Pj::ParteCuerpo"].freeze

  def fullName
    nombre + (isNumeric ? " X" : "")
  end
end
