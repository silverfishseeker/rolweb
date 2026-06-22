class AddTipoEstadisticToTipoCalculado < ActiveRecord::Migration[8.0]
  def change
    add_reference :pj_meta_tipos, :pj_tipo_estadistic, foreign_key: { to_table: :pj_meta_tipos }, index: true
  end
end
