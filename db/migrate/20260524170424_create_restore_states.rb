class CreateRestoreStates < ActiveRecord::Migration[8.0]
  def change
    create_table :restore_states do |t|
      t.integer :index
      t.string :resume_dir

      t.timestamps
    end
  end
end
