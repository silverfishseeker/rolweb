class Pj::Calculado < ApplicationRecord
  #attributes: no other attributes
  belongs_to :hasCalculados, polymorphic: true, inverse_of: :calculados
  belongs_to :modificable,
    class_name: "Pj::Modificable",
    foreign_key: "pj_modificable_id",
    dependent: :destroy,
    autosave: true
    
  belongs_to :tipoCalculado,
    class_name: "Pj::TipoCalculado",
    foreign_key: "tipoCalculado_id",
    optional: true
  has_one :calculado_libre,
    class_name: "CalculadoLibre",
    foreign_key: :pj_calculado_id,
    inverse_of: :calculado,
    dependent: :destroy,
    autosave: true
  has_one :rango,
    class_name: "Pj::Rango",
    foreign_key: :calculado_id,
    inverse_of: :calculado,
    dependent: :destroy,
    autosave: true
  
  validate do 
    if calculado_libre.present? && tipoCalculado.present?
      errors.add(:base, "Calculado no puede tener tipoCalculado si es libre")
    end
  end

  validate do
    if hasCalculados_type != "Personaje" && !calculado_libre.present?
      errors.add(:base, "Si calculado no pertenece a un personaje, debe de ser libre, pertenece a #{hasCalculados_type}")
    end
  end

  def has_libre?
    calculado_libre.present?
  end

  def tipoStatistic
    if has_libre?
      nil
    elsif rango.present?
      rango.tipoRango.tipoEstadistic
    else
      tipoCalculado.tipoEstadistic
    end
  end

  def nombre
    if has_libre?
      calculado_libre.nombre
    elsif rango.present?
      rango.tipoRango.nombre
    else
      tipoCalculado.nombre
    end
  end

  def value
    base = if has_libre?
       calculado_libre.base
    else
      # la segunda validación asegura que hasCalculados sea un personaje si no es libre, por lo que tiene estadistics
      hasCalculados.estadistics.find do |s|
        s.tipo_estadistic_id == tipoStatistic&.id
      end&.value || 0
    end
    sum_nil base, modificable.passive_mod, modificable.active_mod # sum_nil ignora nils
  end
end
