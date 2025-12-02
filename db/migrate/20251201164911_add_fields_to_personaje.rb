class AddFieldsToPersonaje < ActiveRecord::Migration[8.0]
  def change
    add_column :personajes, :nivel_clases, :integer
    add_column :personajes, :nivel_habilidades, :integer
    add_column :personajes, :nivel_estadisticas, :integer
    add_column :personajes, :nivel_otro, :integer
    add_reference :personajes, :picture, null: false, foreign_key: true
  end
end
