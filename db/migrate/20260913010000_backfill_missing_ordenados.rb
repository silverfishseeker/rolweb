class BackfillMissingOrdenados < ActiveRecord::Migration[8.0]
  def up
    [Pj::PersonajeHasClase, Pj::PersonajeHasHabilidad, Pj::PersonajeHasItem].each do |klass|
      klass.find_each do |record|
        Array(record.ordenado_lists).each do |list|
          next if record.ordenados.exists?(list: list)
          min = Pj::Ordenado.where(personaje_id: record.personaje_id, list: list).minimum(:position) || 0
          record.ordenados.create!(personaje_id: record.personaje_id, list: list, position: min - 1)
        end
      end
    end
  end

  def down
    # No hace falta deshacer: solo rellena huecos que faltaban, no hay nada que romper al revertir.
  end
end
