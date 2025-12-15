class Pj::Estadistic < ApplicationRecord
  #attributes: base, lv_mod
  belongs_to :personaje
  belongs_to :tipoEstadistic
  belongs_to :modificable, class_name: "Pj::Modificable", foreign_key: "pj_modificable_id", dependent: :destroy, autosave: true

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
