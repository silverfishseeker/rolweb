class RemovePersonajeDescripcion2 < ActiveRecord::Migration[8.0]
  def up
    ActionText::RichText.where(record_type: "Personaje", name: "descripcion2").destroy_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
