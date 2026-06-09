class RenamePesonajegroupIdInPersonajegroupsUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :personajegroups_users,
                  :pesonajegroup_id,
                  :personajegroup_id
  end
end
