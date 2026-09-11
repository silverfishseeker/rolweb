class AddAmbitoAndPolymorphicToHasEstadoalterados < ActiveRecord::Migration[8.0]
  def change
    add_column :estadoalterados, :ambito, :integer, default: 0, null: false

    add_reference :pj_has_estadoalterados, :target, polymorphic: true
    add_reference :pj_has_estadoalterados, :origen, polymorphic: true
  end
end
