class MigrateItemsMobsDataToMobHasItems < ActiveRecord::Migration[8.0]
  def up
    # INSERT ... SELECT sobre una tabla vacía simplemente no inserta nada, no da error.
    execute <<~SQL
      INSERT INTO mob_has_items (mob_id, item_id, cantidad, created_at, updated_at)
      SELECT mob_id, item_id, 1, NOW(), NOW()
      FROM items_mobs
    SQL
  end

  def down
    execute "DELETE FROM mob_has_items"
  end
end
