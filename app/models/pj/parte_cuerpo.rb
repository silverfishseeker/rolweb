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

  DEFAULT_MAPEOS = {
    1 => ["💀", "S"],
    2 => ["💀", "G", "S"],
    3 => ["💀", "G", "H", "S"],
    4 => ["💀", "G", "H", "S", "S"],
    5 => ["💀", "G", "H", "H", "S", "S"],
    6 => ["💀", "G", "G", "H", "H", "S", "S"],
    7 => ["💀", "G", "G", "H", "H", "S", "S", "S"],
    8 => ["💀", "G", "G", "H", "H", "H", "S", "S", "S"],
    9 => ["💀", "G", "G", "G", "H", "H", "H", "S", "S", "S"],
  }

  DEFAULT_MAPEO_NAME = "DEFAULT_MAPEO"

  validate do
    if mapeo
      unless
          (mapeo == DEFAULT_MAPEO_NAME && DEFAULT_MAPEOS[saludmax]) ||
          str_mapeo_to_list(mapeo).length == saludmax

        errors.add(:mapeo, message: "mapeo: {#{mapeo}} saludmax: #{saludmax}")
      end
    else
      errors.add(:mapeo, "no puede ser nulo")
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
        if mapeo == DEFAULT_MAPEO_NAME && DEFAULT_MAPEOS[saludmax]
          DEFAULT_MAPEOS[saludmax]
        else
          ["💀"] + str_mapeo_to_list(mapeo)
        end
      )[saludact] || DEFAULT_UNKNOWN_STATE
    end
  end

end
