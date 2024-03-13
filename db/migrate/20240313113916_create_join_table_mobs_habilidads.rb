class CreateJoinTableMobsHabilidads < ActiveRecord::Migration[7.0]
  def change
    create_table :mobsHasHabil do |t|
      t.integer :mob_id
      t.integer :habilidad_id

      t.index [:mob_id, :habilidad_id]
      t.index [:habilidad_id, :mob_id]
    end
  end
end
