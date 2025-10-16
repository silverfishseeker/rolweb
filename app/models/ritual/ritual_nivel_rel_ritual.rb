class Ritual::RitualNivelRelRitual < ApplicationRecord
  # atributes: cantidad
  belongs_to :ritual
  belongs_to :ritual_nivel
end
