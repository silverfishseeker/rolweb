class Pj::TipoEstadistic < Pj::MetaTipo
  #attributes: nombre, clave, siglas, orden
  has_many :estadistics,
    class_name: "Pj::Estadistic",
    foreign_key: "tipo_estadistic_id"
end
