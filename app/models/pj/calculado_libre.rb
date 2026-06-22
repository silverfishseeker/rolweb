class Pj::CalculadoLibre < ApplicationRecord
  # attributes: base, nombre
  belongs_to :calculado, class_name: "Pj::Calculado", foreign_key: "pj_calculado_id"
end