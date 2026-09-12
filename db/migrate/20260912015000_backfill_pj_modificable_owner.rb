class BackfillPjModificableOwner < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE pj_modificables
      SET owner_type = 'Pj::Estadistic', owner_id = pj_estadistics.id
      FROM pj_estadistics
      WHERE pj_estadistics.pj_modificable_id = pj_modificables.id
    SQL

    execute <<~SQL
      UPDATE pj_modificables
      SET owner_type = 'Pj::Calculado', owner_id = pj_calculados.id
      FROM pj_calculados
      WHERE pj_calculados.pj_modificable_id = pj_modificables.id
    SQL

    execute <<~SQL
      UPDATE pj_modificables
      SET owner_type = 'Pj::ParteCuerpo', owner_id = pj_parte_cuerpos.id
      FROM pj_parte_cuerpos
      WHERE pj_parte_cuerpos.pj_modificable_id = pj_modificables.id
    SQL
  end

  def down
    # No hace falta deshacer: al revertir la migración que añade owner_type/owner_id
    # esas columnas se eliminan igualmente.
  end
end
