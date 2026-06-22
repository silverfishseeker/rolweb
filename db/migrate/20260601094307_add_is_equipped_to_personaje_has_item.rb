class AddIsEquippedToPersonajeHasItem < ActiveRecord::Migration[8.0]
  def change
    add_column :pj_personaje_has_items, :isEquipped, :boolean, default: false, null: false
  end
end
