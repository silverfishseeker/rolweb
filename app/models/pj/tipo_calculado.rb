class Pj::TipoCalculado < Pj::MetaTipo
  #attributes: nombre, clave, siglas, orden
  has_many :calculados
  belongs_to :tipo_estadistic, class_name: "Pj::TipoEstadistic", foreign_key: "pj_tipo_estadistic_id" #TODO: NEW
end
