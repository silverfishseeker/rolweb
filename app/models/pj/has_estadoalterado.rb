class Pj::HasEstadoalterado < ApplicationRecord
  #attributes: valor
  belongs_to :target, polymorphic: true # A quién afecta: Personaje o Pj::ParteCuerpo
  belongs_to :origen, polymorphic: true # De qué se trata: Estadoalterado (oficial) o Pj::EstadoalteradoLibre (custom)

  before_destroy do
    origen.destroy if origen_type == "Pj::EstadoalteradoLibre"
  end

  validate do
    if origen_type == "Estadoalterado" && origen.ambito.present? && target_type != origen.ambito
      errors.add(:base, "El ámbito de #{origen.nombre} no permite asociarlo a un #{target_type}.")
    end
  end

  def libre?
    origen_type == "Pj::EstadoalteradoLibre"
  end
end
