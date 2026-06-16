class CreatePersonajegroups < ActiveRecord::Migration[8.0]
  def change
    create_table :personajegroups do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
