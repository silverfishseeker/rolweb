class AddNombreToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :nombre, :string
  end
end
