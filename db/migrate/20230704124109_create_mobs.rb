class CreateMobs < ActiveRecord::Migration[7.0]
  def change
    create_table :mobs do |t|
      t.string :nombre
      t.string :image
      t.text :cuerpo
      t.integer :estabilidad
      t.integer :armaduraMagica
      t.integer :penetracionFisica
      t.integer :penetracionMagica
      t.integer :sangre
      t.text :descripcion
      t.decimal :oro

      t.timestamps
    end
  end
end
