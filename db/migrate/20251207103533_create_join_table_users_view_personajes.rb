class CreateJoinTableUsersViewPersonajes < ActiveRecord::Migration[8.0]
  def change
    create_join_table :users, :personajes do |t|
      # t.index [:user_id, :personaje_id]
      # t.index [:personaje_id, :user_id]
    end
  end
end
