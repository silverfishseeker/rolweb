class CreateJoinTableClasesCategs < ActiveRecord::Migration[7.0]
  def change
    create_join_table :clases, :categs do |t|
      # t.index [:clase_id, :categ_id]
      # t.index [:categ_id, :clase_id]
    end
  end
end
