class CreateJoinTableCategsHabilidads < ActiveRecord::Migration[7.0]
  def change
    create_join_table :categs, :habilidads do |t|
      t.index [:categ_id, :habilidad_id]
      t.index [:habilidad_id, :categ_id]
    end
  end
end
