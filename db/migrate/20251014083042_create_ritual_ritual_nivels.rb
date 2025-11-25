class CreateRitualRitualNivels < ActiveRecord::Migration[7.0]
  def change
    create_table :ritual_ritual_nivels do |t|
      t.integer :valor

      t.timestamps
    end
  end
end
