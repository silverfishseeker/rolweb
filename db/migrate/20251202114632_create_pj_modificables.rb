class CreatePjModificables < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_modificables do |t|
      t.integer :passive_mod
      t.integer :active_mod

      t.timestamps
    end
  end
end
