class Patatata < ActiveRecord::Migration[7.0]
  def change
    create_table :habilidads do |t|
      t.string :nombre
      t.integer :nivel
      t.string :efecto
      t.string :image

      t.timestamps
    end
  end
end
