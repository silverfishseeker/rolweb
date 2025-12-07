class CreatePjPersonajeHasItems < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_personaje_has_items do |t|
      t.integer :cantidad
      t.references :personaje, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
