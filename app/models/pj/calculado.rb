class Pj::Calculado < ApplicationRecord
  #attributes: no other attributes
  belongs_to :personaje
  belongs_to :tipoCalculado, optional: true #if nil, it's a custom calculado or has rango
  belongs_to :modificable, class_name: "Pj::Modificable", foreign_key: "pj_modificable_id", dependent: :destroy, autosave: true
  has_one :calculado_libre,
    class_name: "CalculadoLibre",
    foreign_key: :pj_calculado_id,
    inverse_of: :calculado,
    dependent: :destroy,
    autosave: true
  has_one :rango,
    class_name: "Pj::Rango",
    foreign_key: :pj_calculado_id,
    inverse_of: :calculado,
    dependent: :destroy,
    autosave: true
  
  validate do 
    if calculado_libre.present? == tipoCalculado.present?
      errors.add(:base, "Calculado debe ser de un tipo o libre, no ambos ni ninguno")
    end
  end

  def free?
    calculado_libre.present?
  end

  def tipoStatistic
    if free?
      nil
    elsif rango.present?
      rango.tipoRango.tipoEstadistic
    else
      tipoCalculado.tipoEstadistic
    end
  end

  def nombre
    if free?
      calculado_libre.nombre
    elsif rango.present?
      rango.tipoRango.nombre
    else
      tipoCalculado.nombre
    end
  end

  def value
    base = if free?
       calculado_libre.base
    else
      personaje.estadistics.find do |s|
        s.tipoEstadistic_id == tipoStatistic&.id
      end&.value || 0
    end
    sum_nil base, modificable.passive_mod, modificable.active_mod # sum_nil ignora nils
  end
end
