class CreatePictures < ActiveRecord::Migration[7.0]
  def change
    create_table :pictures do |t|
      t.string :nombre
      t.string :image

      t.timestamps
    end
  end
end
