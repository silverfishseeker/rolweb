class CreatePjCalculados < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_calculados do |t|
      t.references :personaje, null: false, foreign_key: true
      t.references :tipoCalculado, null: false, foreign_key: { to_table: :pj_meta_tipos }
      t.references :pj_modificable, null: false, foreign_key: true

      t.timestamps
    end
  end
end
