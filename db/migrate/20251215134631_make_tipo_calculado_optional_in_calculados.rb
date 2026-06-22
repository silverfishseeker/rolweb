class MakeTipoCalculadoOptionalInCalculados < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_calculados, :tipoCalculado_id, true
  end
end
