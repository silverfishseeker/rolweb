class Pj::Modificable < ApplicationRecord
  #attributes: passive_mod, active_mod
  has_one :estadistic,
    class_name: "Pj::Estadistic",
    foreign_key: :pj_modificable_id,
    inverse_of: :modificable,
    dependent: :destroy

  has_one :calculado,
    class_name: "Pj::Calculado",
    foreign_key: :pj_modificable_id,
    inverse_of: :modificable,
    dependent: :destroy

  validate do
    if estadistic && calculado
      errors.add(:base, "Modificable sólo puede ser de un tipo")
    end
  end
end
