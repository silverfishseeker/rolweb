class RenameTipoEstadisticIdInPjEstadistics < ActiveRecord::Migration[8.0]
  def change
    rename_column :pj_estadistics, :tipoEstadistic_id, :tipo_estadistic_id
  end
end
