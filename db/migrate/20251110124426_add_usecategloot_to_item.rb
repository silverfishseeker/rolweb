class AddUsecateglootToItem < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :usecategloot, :boolean, default: true
  end
end
