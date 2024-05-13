class RemoveNivelFromClase < ActiveRecord::Migration[7.0]
  def change
    remove_column :clases, :nivel, :integer
  end
end
