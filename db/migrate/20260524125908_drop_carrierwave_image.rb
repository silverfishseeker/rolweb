class DropCarrierwaveImage < ActiveRecord::Migration[8.0]
  def change
    drop_table :carrierwave_images
  end
end
