class InvertPicturePersonajeRelation < ActiveRecord::Migration[8.0]
  def change
    remove_reference :personajes, :picture, foreign_key: true
    add_reference :pictures, :personaje, foreign_key: true, index: { unique: true }, null: true
  end
end
