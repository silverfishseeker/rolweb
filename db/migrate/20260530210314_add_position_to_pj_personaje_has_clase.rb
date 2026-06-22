class AddPositionToPjPersonajeHasClase < ActiveRecord::Migration[8.0]
  def change
    add_column :pj_personaje_has_clases, :position, :integer
  end
end
