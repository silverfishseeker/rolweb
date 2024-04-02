class AddOcultoToHabilidad < ActiveRecord::Migration[7.0]
  def change
    add_column :habilidads, :oculto, :boolean
  end
end
