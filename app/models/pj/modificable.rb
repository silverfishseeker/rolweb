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

  has_one :parte_cuerpo,
    class_name: "Pj::ParteCuerpo",
    foreign_key: :pj_modificable_id,
    inverse_of: :modificable,
    required: false

  validate do
    if estadistic && calculado || estadistic && parte_cuerpo || calculado && parte_cuerpo
      errors.add(:base, "Modificable sólo puede ser de un tipo")
    end
  end
end
