class NullifyDocumentoRefsOnDelete < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :system_settings, column: :reglas_documento_id
    remove_foreign_key :system_settings, column: :ayuda_documento_id
    remove_foreign_key :system_settings, column: :avisolegal_documento_id

    add_foreign_key :system_settings, :documentos, column: :reglas_documento_id, on_delete: :nullify
    add_foreign_key :system_settings, :documentos, column: :ayuda_documento_id, on_delete: :nullify
    add_foreign_key :system_settings, :documentos, column: :avisolegal_documento_id, on_delete: :nullify
  end
end
