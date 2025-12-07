class Pj::MetaTipo < ApplicationRecord
  #attributes: nombre, clave, siglas, orden
  validates :orden, presence: true, uniqueness: { scope: :type, message: "ya existe dentro de este tipo" }
end
