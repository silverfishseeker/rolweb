class Pj::Calculado < ApplicationRecord
  #attributes: no other attributes
  belongs_to :personaje
  belongs_to :tipoCalculado
  belongs_to :modificable, dependent: :destroy
end
