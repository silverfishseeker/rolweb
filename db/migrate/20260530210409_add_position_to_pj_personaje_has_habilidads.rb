class AddPositionToPjPersonajeHasHabilidads < ActiveRecord::Migration[8.0]
  def change
    add_column :pj_personaje_has_habilidads, :position, :integer
  end
end
