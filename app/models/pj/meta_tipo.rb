class Pj::MetaTipo < ApplicationRecord
  #attributes: nombre, clave, siglas, orden
  validates :orden, presence: true, uniqueness: { scope: :type, message: "ya existe dentro de este tipo" }

  STR_TIPO = {
    "calculado" => Pj::TipoCalculado,
    "estadistic" => Pj::TipoEstadistic,
    "rango" => Pj::TipoRango
  }.freeze

  TIPO_STR = {
    Pj::TipoCalculado  => "tipo_calculado",
    Pj::TipoEstadistic => "tipo_estadistic",
    Pj::TipoRango      => "tipo_rango"
  }.freeze

  STR_STR = {
    "calculado" => "tipo_calculado",
    "estadistic" => "tipo_estadistic",
    "rango" => "tipo_rango"
  }
end
