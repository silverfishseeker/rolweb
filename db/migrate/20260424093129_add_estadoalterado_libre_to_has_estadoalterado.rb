class AddEstadoalteradoLibreToHasEstadoalterado < ActiveRecord::Migration[8.0]
  def change
    add_reference :pj_has_estadoalterados, :pj_estadoalterado_libre, null: false, foreign_key: true
  end
end
