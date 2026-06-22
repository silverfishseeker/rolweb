class CreatePjMetaTipos < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_meta_tipos do |t|
      t.string :nombre
      t.string :clave
      t.string :siglas
      t.integer :orden
      t.string :type

      t.timestamps
    end
  end
end
