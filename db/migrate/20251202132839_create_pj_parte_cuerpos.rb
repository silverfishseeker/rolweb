class CreatePjParteCuerpos < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_parte_cuerpos do |t|
      t.string :nombre
      t.integer :tipo
      t.string :mapeo
      t.integer :saludmax
      t.integer :saludact
      t.references :pj_calculado, null: false, foreign_key: true
      t.references :personaje, null: false, foreign_key: true

      t.timestamps
    end
  end
end
