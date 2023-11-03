class CreateClasesRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :clases_relations do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
  end
end
