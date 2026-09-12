class BackfillPjHasEstadoalteradoOwner < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE pj_has_estadoalterados
      SET target_type = CASE WHEN personaje_id IS NOT NULL THEN 'Personaje' ELSE 'Pj::ParteCuerpo' END,
          target_id = COALESCE(personaje_id, pj_parte_cuerpo_id),
          origen_type = CASE WHEN estadoalterado_id IS NOT NULL THEN 'Estadoalterado' ELSE 'Pj::EstadoalteradoLibre' END,
          origen_id = COALESCE(estadoalterado_id, pj_estadoalterado_libre_id)
    SQL
  end

  def down
    # No hace falta deshacer: al revertir la migración que añade target_type/target_id/origen_type/origen_id
    # esas columnas se eliminan igualmente.
  end
end
