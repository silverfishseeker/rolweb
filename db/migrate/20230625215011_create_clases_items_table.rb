class CreateClasesItemsTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :clases, :items do |t|
      t.index [:clase_id, :item_id]
      t.index [:item_id, :clase_id]
    end
  end
end
