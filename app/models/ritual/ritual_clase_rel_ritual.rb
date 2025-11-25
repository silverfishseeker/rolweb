class Ritual::RitualClaseRelRitual < ApplicationRecord
  # atributes: cantidad
  belongs_to :ritual
  belongs_to :ritual_clase
end
