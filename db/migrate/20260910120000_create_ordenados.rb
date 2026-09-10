class CreateOrdenados < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_ordenados do |t|
      t.references :ordenable, polymorphic: true, null: false
      t.bigint :personaje_id, null: false
      t.integer :list, null: false
      t.integer :position, null: false
      t.timestamps
    end
    add_index :pj_ordenados, [:ordenable_type, :ordenable_id, :list], unique: true, name: "index_pj_ordenados_on_ordenable_and_list"
    add_index :pj_ordenados, [:personaje_id, :list, :position], name: "index_pj_ordenados_on_personaje_list_position"
    add_unique_constraint :pj_ordenados, [:personaje_id, :list, :position], deferrable: :deferred, name: "uniq_pj_ordenados_personaje_list_position"

    remove_column :pj_personaje_has_clases, :position, :integer
    remove_column :pj_personaje_has_habilidads, :position, :integer
    remove_column :pj_personaje_has_items, :position, :integer
  end
end
