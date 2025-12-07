class Pj::Rango < ApplicationRecord
  #attributes: valor
  belongs_to :personaje
  belongs_to :tipoRango
  belongs_to :calculado, dependent: :destroy
end
