class CreatePjEstadistics < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_estadistics do |t|
      t.integer :base
      t.integer :lv_mod
      t.references :personaje, null: false, foreign_key: true
      t.references :tipoEstadistic, null: false, foreign_key: { to_table: :pj_meta_tipos }
      t.references :pj_modificable, null: false, foreign_key: true

      t.timestamps
    end
  end
end
