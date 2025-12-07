class Pj::TipoEstadistic < Pj::MetaTipo
  #attributes: nombre, clave, siglas, orden
  has_many :estadistics
end
