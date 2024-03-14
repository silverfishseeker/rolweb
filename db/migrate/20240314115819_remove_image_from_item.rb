class RemoveImageFromItem < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :image, :string
  end
end
