module PersonajesHelper
  def ea_t_id(index)
    "ea_table_#{index}"
  end

  # Estados alterados de catálogo disponibles para añadir a owner (Personaje o Pj::ParteCuerpo):
  # solo los del ámbito correspondiente (los sin ámbito asignado no se ofrecen nunca).
  def available_estados_for(owner)
    Estadoalterado.where(ambito: owner.class.name).order(:nombre)
  end
end
