class AddOroToPersonaje < ActiveRecord::Migration[8.0]
  def change
    add_column :personajes, :oro, :integer, default: 0, null: false
  end
end
