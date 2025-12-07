class CreatePjPersonajeHasHabilidads < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_personaje_has_habilidads do |t|
      t.references :personaje, null: false, foreign_key: true
      t.references :pj_personaje_has_clase, null: false, foreign_key: true
      t.references :habilidad, null: false, foreign_key: true

      t.timestamps
    end
  end
end
