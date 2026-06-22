class CreateTableCalculadoLibres < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_calculado_libres do |t|
      t.string :nombre
      t.integer :base
      t.references :pj_personaje_has_habilidad, null: false, foreign_key: true
      t.references :pj_personaje_has_clase, null: false, foreign_key: true
      t.references :pj_calculado, null: false, foreign_key: true

      t.timestamps
    end
  end
end
