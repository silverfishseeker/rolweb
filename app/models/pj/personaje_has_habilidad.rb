class Pj::PersonajeHasHabilidad < ApplicationRecord
  belongs_to :personaje
  belongs_to :PersonajeHasClase
  belongs_to :habilidad

  validate do
    if personaje && personajeHasClase
      errors.add(:base, "PersonajeHasHabilidad ser de un personaje y de un PersonajeHasClase a la vez")
    end
  end
  
  has_rich_text :sobreescritura
end
