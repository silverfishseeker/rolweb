class CreateJoinTableContextolootsHabilidads < ActiveRecord::Migration[8.0]
  def change
    create_join_table :contextoloots, :habilidads do |t|
      t.index [:contextoloot_id, :habilidad_id]
      t.index [:habilidad_id, :contextoloot_id]
    end
  end
end
