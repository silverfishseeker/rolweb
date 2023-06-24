class CreateJoinTableClasesHabilidades < ActiveRecord::Migration[7.0]
  def change
    create_join_table :clases, :habilidads do |t|
      t.index [:clase_id, :habilidad_id]
      t.index [:habilidad_id, :clase_id]
    end
  end
end
