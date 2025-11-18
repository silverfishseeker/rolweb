class CreateContextoloots < ActiveRecord::Migration[8.0]
  def change
    create_table :contextoloots do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
