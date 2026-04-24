class CreatePjEstadoalteradoLibres < ActiveRecord::Migration[8.0]
  def change
    create_table :pj_estadoalterado_libres do |t|
      t.timestamps
    end
  end
end
