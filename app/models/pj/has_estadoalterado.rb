class Pj::HasEstadoalterado < ApplicationRecord
  #attributes: valor
  belongs_to :estadoAlterado
  belongs_to :personaje, optional: true
  belongs_to :parteCuerpo, optional: true

  validate do
    if personaje.nil? && parteCuerpo.nil?
      errors.add(:base, "Debe tener un personaje o una parte de cuerpo asociada.")
    end
  end
end
