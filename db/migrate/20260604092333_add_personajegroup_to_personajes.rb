class AddPersonajegroupToPersonajes < ActiveRecord::Migration[8.0]
  def change
    add_reference :personajes, :personajegroup, null: true, foreign_key: true, index: true
  end
end
