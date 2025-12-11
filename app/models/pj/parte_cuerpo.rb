class Pj::ParteCuerpo < ApplicationRecord
  #attributes: nombre, tipo, mapeo, saludmax, saludact
  belongs_to :calculado, dependent: :destroy
  belongs_to :personaje
  has_many :hasEstadoalterados
end
