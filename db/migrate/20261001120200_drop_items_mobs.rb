class DropItemsMobs < ActiveRecord::Migration[8.0]
  def change
    drop_table :items_mobs, id: false do |t|
      t.bigint :mob_id, null: false
      t.bigint :item_id, null: false
      t.index [:item_id, :mob_id], name: "index_items_mobs_on_item_id_and_mob_id"
      t.index [:mob_id, :item_id], name: "index_items_mobs_on_mob_id_and_item_id"
    end
  end
end
