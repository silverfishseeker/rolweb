class Pj::ParteCuerpo < ApplicationRecord
  #attributes: nombre, tipo, mapeo, saludmax, saludact
  has_one :modificable, as: :owner, class_name: "Pj::Modificable", dependent: :destroy, autosave: true
  has_many :hasEstadoalterados,
    class_name: "Pj::HasEstadoalterado",
    as: :target,
    dependent: :destroy,
    autosave: true

  TIPOS = {
    0 => "Baja",
    1 => "Alta",
    2 => "Muy alta"
  }

  DEFAULT_UNKNOWN_STATE = "?"

  def default_mapeos sMax 
    case sMax
    when 1
      ["💀", "S"]
    when 2
      ["💀", "G", "S"]
    when 3
      ["💀", "G", "H", "S"]
    when 4
      ["💀", "G", "H", "S", "S+"]
    else
      ss = sMax / 2 
      hs = sMax - 1 - ss
      ["💀"] + ["G"] + ["H"] * hs + ["S"] * ss
    end
  end

  DEFAULT_MAPEO_NAME = "DEFAULT_MAPEO"

  validate do
    if mapeo
      unless mapeo == DEFAULT_MAPEO_NAME || str_mapeo_to_list(mapeo).length == saludmax
        errors.add(:mapeo, message: "mapeo: {#{mapeo}} saludmax: #{saludmax}")
      end
    else
      errors.add(:mapeo, "no puede ser nulo")
    end

    if saludmax < 1
      errors.add(:saludmax, "debe ser mayor a 0")
    end
  end

  def is_mapeo
    mapeo != DEFAULT_MAPEO_NAME
  end

  def str_mapeo_to_list str_mapeo
    if str_mapeo.include?("@")
      str_mapeo.split("@").map(&:strip)
    else
      str_mapeo.chars.map(&:strip)
    end
  end

  def state
    if saludact < 0
      DEFAULT_UNKNOWN_STATE
    else
      (@curr_mapeo ||=
        if mapeo == DEFAULT_MAPEO_NAME && default_mapeos(saludmax)
          default_mapeos(saludmax)
        else
          ["💀"] + str_mapeo_to_list(mapeo)
        end
      )[saludact] || DEFAULT_UNKNOWN_STATE
    end
  end

end
