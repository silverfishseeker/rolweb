class Pj::TipoCalculado < Pj::MetaTipo
  #attributes: nombre, clave, siglas, orden
  has_many :calculados
end
