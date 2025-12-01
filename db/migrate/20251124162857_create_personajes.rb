class CreatePersonajes < ActiveRecord::Migration[8.0]
  def change
    create_table :personajes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :nombre

      t.timestamps
    end
  end
end
