class RemoveResumeDirFromRestoreStates < ActiveRecord::Migration[8.0]
  def change
    remove_column :restore_states, :resume_dir, :string
  end
end
