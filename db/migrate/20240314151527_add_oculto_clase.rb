class AddOcultoClase < ActiveRecord::Migration[7.0]
  def change
    add_column :clases, :oculto, :boolean, default: false, null: false
  end
end
