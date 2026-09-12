class Pj::EstadoalteradoLibre < ApplicationRecord
  #attributes: contenido
  has_one :has_estadoalterado, class_name: "Pj::HasEstadoalterado", as: :origen
end
