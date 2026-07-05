class AddOcultoToCuento < ActiveRecord::Migration[8.0]
  def change
    add_column :cuentos, :oculto, :boolean, default: false, null: false
  end
end
