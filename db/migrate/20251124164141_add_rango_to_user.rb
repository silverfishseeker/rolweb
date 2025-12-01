class AddRangoToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :rango, :integer
  end
end
