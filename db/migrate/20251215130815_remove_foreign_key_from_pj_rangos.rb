class RemoveForeignKeyFromPjRangos < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :pj_rangos, :personajes
  end
end
