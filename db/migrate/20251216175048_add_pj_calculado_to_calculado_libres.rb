class AddPjCalculadoToCalculadoLibres < ActiveRecord::Migration[8.0]
  def change
    add_reference :pj_calculado_libres,
                  :pj_calculado,
                  null: false,
                  foreign_key: { to_table: :pj_calculados }
  end
end
