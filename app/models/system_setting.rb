class SystemSetting < ApplicationRecord
  def self.instance
    first_or_create!
  end

  def self.arbol_image
    SystemSetting.instance.image
  end
  
  mount_image_uploader mode: :original # Arbol de Clases

  belongs_to :habilidades_independientes_clase, # Clase de Habilidades Independientes
             class_name: "Clase",
             optional: true
end