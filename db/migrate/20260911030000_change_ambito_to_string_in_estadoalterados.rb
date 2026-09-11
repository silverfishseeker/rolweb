class ChangeAmbitoToStringInEstadoalterados < ActiveRecord::Migration[8.0]
  def up
    remove_column :estadoalterados, :ambito
    add_column :estadoalterados, :ambito, :string
  end

  def down
    remove_column :estadoalterados, :ambito
    add_column :estadoalterados, :ambito, :integer, default: 0, null: false
  end
end
