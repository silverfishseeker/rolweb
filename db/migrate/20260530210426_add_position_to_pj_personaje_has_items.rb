class AddPositionToPjPersonajeHasItems < ActiveRecord::Migration[8.0]
  def change
    add_column :pj_personaje_has_items, :position, :integer
  end
end
