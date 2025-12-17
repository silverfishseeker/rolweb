class AllowNullPictureIdInPersonajes < ActiveRecord::Migration[8.0]
  def change
    change_column_null :personajes, :picture_id, true
  end
end
