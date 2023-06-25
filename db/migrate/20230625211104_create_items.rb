class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :nombre
      t.decimal :coste
      t.decimal :peso
      t.text :efecto
      t.string :image

      t.timestamps
    end
  end
end
