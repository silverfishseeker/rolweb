class CreateEstadoalterado < ActiveRecord::Migration[7.0]
  def change
    create_table :estadoalterados do |t|
      t.string :nombre

      t.timestamps
    end
  end
end