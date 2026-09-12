class AddOwnerToPjModificables < ActiveRecord::Migration[8.0]
  def change
    add_reference :pj_modificables, :owner, polymorphic: true
  end
end
