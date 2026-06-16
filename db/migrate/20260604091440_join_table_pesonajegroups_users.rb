class JoinTablePesonajegroupsUsers < ActiveRecord::Migration[8.0]
  def change
    create_join_table :pesonajegroups, :users do |t|
      t.index [:pesonajegroup_id, :user_id]
      t.index [:user_id, :pesonajegroup_id]
    end
  end
end
