# On include, the model must define `ordenado_lists` returning an array of symbols choosing from thee enum of Ordenado
module Ordenable
  extend ActiveSupport::Concern

  included do
    has_many :ordenados, as: :ordenable, class_name: "Pj::Ordenado", dependent: :destroy, autosave: true

    after_create do
      Array(ordenado_lists).each do |list|
        begin
          Pj::Ordenado.transaction(requires_new: true) do
            position = @pending_orden&.dig(list) || (Pj::Ordenado.where(personaje_id: personaje_id, list: list).minimum(:position) || 0) - 1
            ordenados.create!(personaje_id: personaje_id, list: list, position: position)
          end
        rescue ActiveRecord::RecordNotUnique # Condición de carrera
          (tries = (tries || 0) + 1) < 10 ? retry : raise
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

  def set_orden(list = ordenado_lists.first, position)
    if existing = ordenado_for(list)
      existing.position = position
    else
      (@pending_orden ||= {})[list] = position
    end
  end
end
