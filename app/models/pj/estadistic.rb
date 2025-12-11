class Pj::Estadistic < ApplicationRecord
  #attributes: base, lv_mod
  belongs_to :personaje
  belongs_to :tipoEstadistic
  belongs_to :modificable, class_name: "Pj::Modificable", foreign_key: "pj_modificable_id", dependent: :destroy

  def value
    sum_nil base, lv_mod, modificable.passive_mod, modificable.active_mod # sum_nil ignora nils
  end
end
