class RemovePjCalculadoFromPjParteCuerpos < ActiveRecord::Migration[8.0]
  def change
    remove_reference :pj_parte_cuerpos, :pj_calculado, null: false, foreign_key: true
  end
end
