class AddImageToHabilidad < ActiveRecord::Migration[7.0]
  def change
    add_column :habilidads, :image, :string
  end
end
