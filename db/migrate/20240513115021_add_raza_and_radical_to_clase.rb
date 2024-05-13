class AddRazaAndRadicalToClase < ActiveRecord::Migration[7.0]
  def change
    add_column :clases, :raza, :boolean, default: false, null: false
    add_column :clases, :radical, :boolean, default: false, null: false
  end
end
