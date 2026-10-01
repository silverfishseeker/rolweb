class CreateMobHasItems < ActiveRecord::Migration[8.0]
  def change
    create_table :mob_has_items do |t|
      t.integer :cantidad
      t.references :mob, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
