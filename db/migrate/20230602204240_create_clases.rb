class CreateClases < ActiveRecord::Migration[7.0]
  def change
    create_table :clases do |t|
      t.string :nombre
      t.integer :nivel
      t.text :efecto
      t.text :descripcion

      t.timestamps
    end
  end
end
