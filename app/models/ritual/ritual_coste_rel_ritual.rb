class Ritual::RitualCosteRelRitual < ApplicationRecord
  # atributes: cantidad
  belongs_to :ritual
  belongs_to :ritual_coste
end
