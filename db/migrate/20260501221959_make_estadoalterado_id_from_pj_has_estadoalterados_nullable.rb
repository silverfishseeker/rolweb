class MakeEstadoalteradoIdFromPjHasEstadoalteradosNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_has_estadoalterados, :estadoalterado_id, true
  end
end
