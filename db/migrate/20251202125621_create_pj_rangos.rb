class CreatePjRangos < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_rangos do |t|
      t.integer :valor
      t.references :personaje, null: false, foreign_key: true
      t.references :tipoRango, null: false, foreign_key: { to_table: :pj_meta_tipos }
      t.references :pj_calculado, null: false, foreign_key: true

      t.timestamps
    end
  end
end
