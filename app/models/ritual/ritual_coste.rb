class Ritual::RitualCoste < ApplicationRecord
  # atributes: valor
  has_many :ritual_coste_rel_rituals, dependent: :destroy
end
