class RemovePjModificableIdFromOwners < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_modificables, :owner_type, false
    change_column_null :pj_modificables, :owner_id, false

    remove_reference :pj_estadistics, :pj_modificable, foreign_key: true, null: false
    remove_reference :pj_calculados, :pj_modificable, foreign_key: true, null: false
    remove_reference :pj_parte_cuerpos, :pj_modificable, foreign_key: true, null: false
  end
end
