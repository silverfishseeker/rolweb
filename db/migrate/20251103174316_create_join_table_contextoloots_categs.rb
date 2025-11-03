class CreateJoinTableContextolootsCategs < ActiveRecord::Migration[8.0]
  def change
    create_join_table :contextoloots, :categs do |t|
      # t.index [:contextoloot_id, :categ_id]
      # t.index [:categ_id, :contextoloot_id]
    end
  end
end
