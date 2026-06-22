class CreatePjHasEstadoalterados < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_has_estadoalterados do |t|
      t.integer :valor
      t.references :personaje, null: false, foreign_key: true
      t.references :estadoalterado, null: false, foreign_key: true
      t.references :pj_parte_cuerpo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
