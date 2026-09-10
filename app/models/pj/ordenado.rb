class Pj::Ordenado < ApplicationRecord
  belongs_to :ordenable, polymorphic: true
  belongs_to :personaje

  enum :list, { activas: 0, pasivas: 1, otras: 2, equipo: 3, inventario: 4 }

  validates :position, presence: true
  validates :list, presence: true
end
