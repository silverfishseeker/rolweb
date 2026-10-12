class Pj::Ordenado < ApplicationRecord
  # attributes: position, list
  belongs_to :ordenable, polymorphic: true
  belongs_to :personaje

  enum :list, { activas: 0, pasivas: 1, otras: 2, equipo: 3, inventario: 4, partes_cuerpo: 5, estadisticas: 6, calculados: 7 }

  validates :list, presence: true
end
