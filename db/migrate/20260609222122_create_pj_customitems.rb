class CreatePjCustomitems < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_customitems do |t|
      t.string :nombre

      t.references :personaje_has_item,
                   null: false,
                   index: { unique: true },
                   foreign_key: { to_table: :pj_personaje_has_items }
                   
      t.timestamps
    end
  end
end
