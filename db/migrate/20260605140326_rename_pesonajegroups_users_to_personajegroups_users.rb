class RenamePesonajegroupsUsersToPersonajegroupsUsers < ActiveRecord::Migration[8.0]
  def change
    rename_table :pesonajegroups_users, :personajegroups_users
  end
end
