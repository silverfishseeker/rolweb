class CreateJoinTableContextolootsItems < ActiveRecord::Migration[8.0]
  def change
    create_join_table :contextoloots, :items do |t|
      # t.index [:contextoloot_id, :item_id]
      # t.index [:item_id, :contextoloot_id]
    end
  end
end
