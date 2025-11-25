class CreateRitualRituals < ActiveRecord::Migration[7.0]
  def change
    create_table :ritual_rituals do |t|

      t.timestamps
    end
  end
end
