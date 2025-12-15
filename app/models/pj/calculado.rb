class Pj::Calculado < ApplicationRecord
  #attributes: no other attributes
  belongs_to :personaje
  belongs_to :tipoCalculado, optional: true #if nil, it's a custom calculado
  belongs_to :modificable, class_name: "Pj::Modificable", foreign_key: "pj_modificable_id", dependent: :destroy, autosave: true
  has_one :calculado_libre,
    class_name: "CalculadoLibre",
    foreign_key: :pj_calculado_id,
    inverse_of: :calculado,
    dependent: :destroy, autosave: true
  
  validate do 
    if calculado_libre.present? == tipoCalculado.present?
      errors.add(:base, "Calculado debe ser de un tipo o libre, no ambos ni ninguno")
    end
  end
end
