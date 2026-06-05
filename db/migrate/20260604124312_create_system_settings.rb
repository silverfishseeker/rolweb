class CreateSystemSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :system_settings do |t|
      t.references :habilidades_independientes_clase,
              foreign_key: { to_table: :clases },
              null: true

      t.timestamps
    end
  end
end
