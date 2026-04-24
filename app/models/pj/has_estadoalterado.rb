class Pj::HasEstadoalterado < ApplicationRecord
  #attributes: valor
  belongs_to :personaje, optional: true
  belongs_to :estadoalterado, optional: true
  belongs_to :estadoalteradoLibre, 
             class_name: "Pj::EstadoalteradoLibre",
             optional: true,
             dependent: :destroy
  belongs_to :parteCuerpo,
             class_name: "Pj::ParteCuerpo",
             foreign_key: :pj_parte_cuerpo_id,
             optional: true

  validate do 
    if estadoalterado.present? == estadoalteradoLibre.present?
      errors.add(:base, "HasEstadoalterado debe tener un estado alterado o un estado alterado libre asociado, pero no ambos.")
    end
  end

  validate do
    if personaje.nil? && parteCuerpo.nil?
      errors.add(:base, "HasEstadoalterado debe tener un personaje o una parte de cuerpo asociada.")
    end
  end

  validate do 
    if personaje.present? && parteCuerpo.present?
      errors.add(:base, "HasEstadoalterado no puede tener un personaje y una parte de cuerpo asociada a la vez.")
    end
  end
end
