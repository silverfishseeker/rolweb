class ChangePersonajeHasHabilidadToBelongToOnlyPersonaje < ActiveRecord::Migration[8.0]
  def change
    add_reference :pj_personaje_has_habilidads, :personaje, null: true, foreign_key: true
    remove_column :pj_personaje_has_habilidads, :hasHabilidads_id, :bigint
    remove_column :pj_personaje_has_habilidads, :hasHabilidads_type, :string
  end
end
