class CreateDocumentos < ActiveRecord::Migration[8.0]
  def change
    create_table :documentos do |t|
      t.text :contenido

      t.timestamps
    end
  end
end
