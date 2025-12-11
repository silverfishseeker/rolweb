class AddIsPublicToPersonajes < ActiveRecord::Migration[8.0]
  def change
    add_column :personajes, :is_public, :boolean
  end
end
