class AddPjModificableToParteCuerpos < ActiveRecord::Migration[8.0]
  def change
    add_reference :pj_parte_cuerpos, :pj_modificable, null: false, foreign_key: true
  end
end
