class RemovePersonajeFromPjRangos < ActiveRecord::Migration[8.0]
  def change
    remove_column :pj_rangos, :personaje_id
  end
end
