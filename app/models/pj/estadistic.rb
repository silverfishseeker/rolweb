class Pj::Estadistic < ApplicationRecord
  #attributes: base, lv_mod
  belongs_to :personaje
  belongs_to :tipoEstadistic
  belongs_to :modificable, dependent: :destroy
end
