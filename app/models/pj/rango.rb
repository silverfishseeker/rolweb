class Pj::Rango < ApplicationRecord
  #attributes: valor
  belongs_to :tipoRango, optional: true
  belongs_to :calculado, 
    class_name: "Pj::Calculado", 
    foreign_key: "calculado_id"
end
