class RemoveOldOwnerColumnsFromPjHasEstadoalterados < ActiveRecord::Migration[8.0]
  def up
    change_column_null :pj_has_estadoalterados, :target_type, false
    change_column_null :pj_has_estadoalterados, :target_id, false
    change_column_null :pj_has_estadoalterados, :origen_type, false
    change_column_null :pj_has_estadoalterados, :origen_id, false

    remove_reference :pj_has_estadoalterados, :personaje, foreign_key: true
    remove_reference :pj_has_estadoalterados, :pj_parte_cuerpo, foreign_key: true
    remove_reference :pj_has_estadoalterados, :estadoalterado, foreign_key: true
    remove_reference :pj_has_estadoalterados, :pj_estadoalterado_libre, foreign_key: true
  end

  def down
    add_reference :pj_has_estadoalterados, :personaje, foreign_key: true
    add_reference :pj_has_estadoalterados, :pj_parte_cuerpo, foreign_key: true
    add_reference :pj_has_estadoalterados, :estadoalterado, foreign_key: true
    add_reference :pj_has_estadoalterados, :pj_estadoalterado_libre, foreign_key: true

    change_column_null :pj_has_estadoalterados, :target_type, true
    change_column_null :pj_has_estadoalterados, :target_id, true
    change_column_null :pj_has_estadoalterados, :origen_type, true
    change_column_null :pj_has_estadoalterados, :origen_id, true
  end
end
