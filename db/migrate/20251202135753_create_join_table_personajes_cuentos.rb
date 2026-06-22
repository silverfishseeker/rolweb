class CreateJoinTablePersonajesCuentos < ActiveRecord::Migration[8.0]
  def change
    create_join_table :personajes, :cuentos do |t|
      # t.index [:personaje_id, :cuento_id]
      # t.index [:cuento_id, :personaje_id]
    end
  end
end
