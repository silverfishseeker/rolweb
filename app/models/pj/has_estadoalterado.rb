class Pj::HasEstadoalterado < ApplicationRecord
  #attributes: valor
  belongs_to :personaje
  belongs_to :EstadoAlterado
  belongs_to :parteCuerpo
end
