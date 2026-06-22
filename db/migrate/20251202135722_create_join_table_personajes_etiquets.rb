class CreateJoinTablePersonajesEtiquets < ActiveRecord::Migration[8.0]
  def change
    create_join_table :personajes, :etiquets do |t|
      # t.index [:personaje_id, :etiquet_id]
      # t.index [:etiquet_id, :personaje_id]
    end
  end
end
