class CreateJoinTableHabilidadsMobs < ActiveRecord::Migration[7.0]
  def change
    create_join_table :habilidads, :mobs do |t|
      t.index [:habilidad_id, :mob_id]
      t.index [:mob_id, :habilidad_id]
    end
  end
end
