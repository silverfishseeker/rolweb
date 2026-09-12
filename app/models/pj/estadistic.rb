class Pj::Estadistic < ApplicationRecord
  #attributes: base, lv_mod
  belongs_to :personaje
  belongs_to :tipoEstadistic,
    class_name: "Pj::TipoEstadistic",
    foreign_key: "tipo_estadistic_id"
  has_one :modificable,
    as: :owner,
    class_name: "Pj::Modificable",
    dependent: :destroy,
    autosave: true

  scope :ordered, -> { joins(:tipoEstadistic).order(:orden) }

  def value
    sum_nil base, lv_mod, modificable.passive_mod, modificable.active_mod # sum_nil ignora nils
  end

  def mod
    (value/2-5).floor
  end

  def mod_str
    mod>=0 ? "+#{mod}" : mod.to_s
  end
end
