class MakeItemIdNullableInPjPersonajeHasItems < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_personaje_has_items, :item_id, true
  end
end
