class AddimageToClase < ActiveRecord::Migration[7.0]
  def change
    add_column :clases, :image, :string
  end
end
