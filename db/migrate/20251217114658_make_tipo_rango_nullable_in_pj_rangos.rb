class MakeTipoRangoNullableInPjRangos < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_rangos, :tipoRango_id, true
  end
end
