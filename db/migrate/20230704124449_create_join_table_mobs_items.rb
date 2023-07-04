class CreateJoinTableMobsItems < ActiveRecord::Migration[7.0]
  def change
    create_join_table :mobs, :items do |t|
      t.index [:mob_id, :item_id]
      t.index [:item_id, :mob_id]
    end
  end
end
