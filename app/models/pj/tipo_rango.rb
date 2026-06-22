class Pj::TipoRango < Pj::MetaTipo
  #attributes: nombre, clave, siglas, orden
  has_many :rangos,
    class_name: "Pj::Rango",
    foreign_key: "tipoRango_id"
  belongs_to :tipoEstadistic,
    class_name: "Pj::TipoEstadistic",
    foreign_key: "pj_tipo_estadistic_id",
    optional: true
end
