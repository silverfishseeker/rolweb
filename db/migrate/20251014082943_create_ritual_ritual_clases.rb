class CreateRitualRitualClases < ActiveRecord::Migration[7.0]
  def change
    create_table :ritual_ritual_clases do |t|
      t.string :valor

      t.timestamps
    end
  end
end
