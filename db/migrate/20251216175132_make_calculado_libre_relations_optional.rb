class MakeCalculadoLibreRelationsOptional < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_calculado_libres, :pj_personaje_has_habilidad_id, true
    change_column_null :pj_calculado_libres, :pj_personaje_has_clase_id, true
  end
end
