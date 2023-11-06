class CreateCategs < ActiveRecord::Migration[7.0]
  def change
    create_table :categs do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
