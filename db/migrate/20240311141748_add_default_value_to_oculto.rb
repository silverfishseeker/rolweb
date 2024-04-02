class AddDefaultValueToOculto < ActiveRecord::Migration[7.0]
  def change
    change_column_default :habilidads, :oculto, from: nil, to: false
  end
end
