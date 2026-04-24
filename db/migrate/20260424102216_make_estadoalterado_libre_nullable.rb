class MakeEstadoalteradoLibreNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_has_estadoalterados, :pj_estadoalterado_libre_id, true
  end
end
