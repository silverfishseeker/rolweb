class Pj::TipoCalculado < Pj::MetaTipo
  #attributes: nombre, clave, siglas, orden
  has_many :calculados,
    class_name: "Pj::Calculado",
    foreign_key: "tipoCalculado_id"
  belongs_to :tipoEstadistic,
    class_name: "Pj::TipoEstadistic",
    foreign_key: "pj_tipo_estadistic_id",
    optional: true
end
