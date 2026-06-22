class RenameHasHabilidadsIdFromPjPersonajeHasHabilidadsToHasHabilidadsId < ActiveRecord::Migration[8.0]
  def change
    rename_column :pj_personaje_has_habilidads, :has_habilidads_id, :hasHabilidads_id
  end
end 