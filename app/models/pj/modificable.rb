class Pj::Modificable < ApplicationRecord
  #attributes: passive_mod, active_mod
  has_one :estadistic
  has_one :calculado

  validate do
    if estadistic && calculado
      errors.add(:base, "Modificable sólo puede ser de un tipo")
    end
  end
end
