class CreateJoinTableCategsCategorys < ActiveRecord::Migration[7.0]
  def change
    create_join_table :items, :categs do |t|
      t.index [:item_id, :categ_id]
      t.index [:categ_id, :item_id]
    end
  end
end
