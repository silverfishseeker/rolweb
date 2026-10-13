class AddDocumentoRefsToSystemSettings < ActiveRecord::Migration[8.0]
  def change
    add_reference :system_settings, :reglas_documento, foreign_key: { to_table: :documentos }, null: true
    add_reference :system_settings, :ayuda_documento, foreign_key: { to_table: :documentos }, null: true
    add_reference :system_settings, :avisolegal_documento, foreign_key: { to_table: :documentos }, null: true
  end
end
