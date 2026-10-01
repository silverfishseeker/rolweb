class Pj::Ordenado < ApplicationRecord
  belongs_to :ordenable, polymorphic: true
  belongs_to :personaje

  enum :list, { activas: 0, pasivas: 1, otras: 2, equipo: 3, inventario: 4, partes_cuerpo: 5, estadisticas: 6, calculados: 7 }

  MENSAJE_ORDEN_PENDIENTE_GUARDAR = "Debe guardarse primero una vez para poder cambiar el orden"

  validates :position, presence: true
  validates :list, presence: true
end
