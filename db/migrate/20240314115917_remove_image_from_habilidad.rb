class RemoveImageFromHabilidad < ActiveRecord::Migration[7.0]
  def change
    remove_column :habilidads, :image, :string
  end
end
