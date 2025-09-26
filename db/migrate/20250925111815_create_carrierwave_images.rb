class CreateCarrierwaveImages < ActiveRecord::Migration[7.0]
  def change
    create_table :carrierwave_images do |t|
      t.string :nombre
      t.string :file
      t.string :content_type

      t.timestamps
    end
  end
end
