class AddRitualRelations < ActiveRecord::Migration[7.0]
  def change
    change_table :ritual_ritual_clase_rel_rituals do |t|
      t.references :ritual, null: false, foreign_key: { to_table: :ritual_rituals }
      t.references :ritual_clase, null: false, foreign_key: { to_table: :ritual_ritual_clases }
    end

    change_table :ritual_ritual_coste_rel_rituals do |t|
      t.references :ritual, null: false, foreign_key: { to_table: :ritual_rituals }
      t.references :ritual_coste, null: false, foreign_key: { to_table: :ritual_ritual_costes }
    end

    change_table :ritual_ritual_nivel_rel_rituals do |t|
      t.references :ritual, null: false, foreign_key: { to_table: :ritual_rituals }
      t.references :ritual_nivel, null: false, foreign_key: { to_table: :ritual_ritual_nivels }
    end

    change_table :ritual_rituals do |t|
      t.references :item, foreign_key: true
    end
  end
end
