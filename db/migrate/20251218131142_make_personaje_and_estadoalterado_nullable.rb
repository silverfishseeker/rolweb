class MakePersonajeAndEstadoalteradoNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_has_estadoalterados, :personaje_id, true
    change_column_null :pj_has_estadoalterados, :estadoalterado_id, true
  end
end
