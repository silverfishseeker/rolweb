class Ritual::RitualClase < ApplicationRecord
  # atributes: valor
  has_many :ritual_clase_rel_rituals, dependent: :destroy
end
