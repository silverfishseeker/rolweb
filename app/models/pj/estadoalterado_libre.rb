class Pj::EstadoalteradoLibre < ApplicationRecord
  #attributes: descripcion
  has_one :has_estadoalterado, class_name: "Pj::HasEstadoalterado", dependent: :destroy

  has_rich_text :descripcion
end
