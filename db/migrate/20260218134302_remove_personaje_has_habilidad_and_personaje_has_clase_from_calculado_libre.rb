class RemovePersonajeHasHabilidadAndPersonajeHasClaseFromCalculadoLibre < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :pj_calculado_libres, :pj_personaje_has_habilidads
    remove_foreign_key :pj_calculado_libres, :pj_personaje_has_clases
    remove_reference :pj_calculado_libres, :pj_personaje_has_habilidad, index: true
    remove_reference :pj_calculado_libres, :pj_personaje_has_clase, index: true
  end
end
