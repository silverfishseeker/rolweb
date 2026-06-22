class ChangePersonajeAndPersonajeHasClaseFromPjPersonajeHasHabilidadIntoPolymorphicHasHabilidads < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :pj_personaje_has_habilidads, :personajes
    remove_foreign_key :pj_personaje_has_habilidads, :pj_personaje_has_clases
    remove_reference :pj_personaje_has_habilidads, :personaje, index: true
    remove_reference :pj_personaje_has_habilidads, :pj_personaje_has_clase, index: true

    add_reference :pj_personaje_has_habilidads, :has_habilidads, polymorphic: true, index: true, null: false
  end
end
