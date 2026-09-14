class AddPesoToPjCustomitems < ActiveRecord::Migration[8.0]
  def change
    add_column :pj_customitems, :peso, :decimal, default: 0, null: false
  end
end
