class CreatePjPersonajeHasClases < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_personaje_has_clases do |t|
      t.integer :nivel
      t.references :personaje, null: false, foreign_key: true
      t.references :clase, null: false, foreign_key: true

      t.timestamps
    end
  end
end
