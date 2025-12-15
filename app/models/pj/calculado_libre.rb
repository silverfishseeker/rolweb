class Pj::CalculadoLibre < ApplicationRecord
  # attributes: base, nombre
  belongs_to :calculado, class_name: "Pj::Calculado", foreign_key: "pj_calculado_id", dependent: :destroy, autosave: true
  belongs_to :personaje_has_habilidad, class_name: "Pj::PersonajeHasHabilidad", foreign_key: "pj_personaje_has_habilidad_id"
  belongs_to :personaje_has_clase, class_name: "Pj::PersonajeHasClase", foreign_key: "pj_personaje_has_clase_id"

  validate do
    if personaje_has_habilidad.present? && personaje_has_clase.present?
      errors.add(:base, "CalculadoLibre no puede estar asociado a una habilidad y una clase a la vez")
    end
  end
end