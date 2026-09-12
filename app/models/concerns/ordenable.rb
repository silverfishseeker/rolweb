module Ordenable
  extend ActiveSupport::Concern

  included do
    has_many :ordenados, as: :ordenable, class_name: "Pj::Ordenado", dependent: :destroy

    after_create do
      Array(ordenado_lists).each do |list|
        attempts = 0
        begin
          attempts += 1
          Pj::Ordenado.transaction(requires_new: true) do
            min = Pj::Ordenado.where(personaje_id: personaje_id, list: list).minimum(:position) || 0
            ordenados.create!(personaje_id: personaje_id, list: list, position: min - 1)
          end
        rescue ActiveRecord::RecordNotUnique # Condición de carrera
          retry if attempts < 10
          raise
        end
      end
    end
  end

  def ordenado_for(list = ordenado_lists.first)
    ordenados.find { |o| o.list.to_sym == list.to_sym }
  end

  def ordenado_position(list = ordenado_lists.first)
    ordenado_for(list)&.position
  end
end
