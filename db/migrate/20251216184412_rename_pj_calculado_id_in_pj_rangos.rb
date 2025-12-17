class RenamePjCalculadoIdInPjRangos < ActiveRecord::Migration[8.0]
  def change
    rename_column :pj_rangos, :pj_calculado_id, :calculado_id
  end
end
