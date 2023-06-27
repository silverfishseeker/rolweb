class CreateJoinTableItemsHabilidads < ActiveRecord::Migration[7.0]
  def change
    create_join_table :items, :habilidads do |t|
      t.index [:item_id, :habilidad_id]
      t.index [:habilidad_id, :item_id]
    end
  end
end
