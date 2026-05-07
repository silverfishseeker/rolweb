class AddContenidoToPjEstadoalteradoLibres < ActiveRecord::Migration[8.0]
  def change
    add_column :pj_estadoalterado_libres, :contenido, :string
  end
end
