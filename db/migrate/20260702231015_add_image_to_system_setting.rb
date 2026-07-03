class AddImageToSystemSetting < ActiveRecord::Migration[8.0]
  def change
    add_column :system_settings, :image, :string
  end
end
