class SystemSetting < ApplicationRecord
  belongs_to :habilidades_independientes_clase,
             class_name: "Clase",
             optional: true
  def self.instance
    first_or_create!
  end
end