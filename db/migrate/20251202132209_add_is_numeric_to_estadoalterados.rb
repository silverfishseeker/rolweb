class AddIsNumericToEstadoalterado < ActiveRecord::Migration[8.0]
  def change
    add_column :estadoalterados, :isNumeric, :boolean
  end
end
