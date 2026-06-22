class ChangePersonajeFromPjCalculadoToPolymorphic < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :pj_calculados, :personajes
    remove_reference :pj_calculados, :personaje, index: true

    add_reference :pj_calculados, :hasCalculados, polymorphic: true, index: true, null: false
  end
end
