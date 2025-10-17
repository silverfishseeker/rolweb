class Ritual::RitualNivel < ApplicationRecord
  # atributes: valor
  has_many :ritual_nivel_rel_rituals, dependent: :destroy
end
