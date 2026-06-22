class MakeEstadoALteradoNotNullableAndParteCuerpoNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_has_estadoalterados, :estadoalterado_id, false
    change_column_null :pj_has_estadoalterados, :pj_parte_cuerpo_id, true
  end
end
