class CreateRitualRitualNivelRelRituals < ActiveRecord::Migration[7.0]
  def change
    create_table :ritual_ritual_nivel_rel_rituals do |t|
      t.integer :cantidad

      t.timestamps
    end
  end
end
