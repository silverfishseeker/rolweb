class AllowNullPositionOnPjOrdenados < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pj_ordenados, :position, true
  end
end
