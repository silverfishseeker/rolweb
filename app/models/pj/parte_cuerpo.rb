class Pj::ParteCuerpo < ApplicationRecord
  #attributes: nombre, tipo, mapeo, saludmax, saludact
  belongs_to :modificable, class_name: "Pj::Modificable", foreign_key: "pj_modificable_id", dependent: :destroy, autosave: true
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
    1 => ["X", "S"],
    2 => ["X", "G", "S"],
    3 => ["X", "G", "H", "S"],
    4 => ["X", "G", "H", "S", "S+"],
    5 => ["X", "G", "H", "H", "S", "S+"]
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

  def list_mapeo_to_s list_mapeo
    list_mapeo.join("@")
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
          str_mapeo_to_list(mapeo)
        end
      )[saludact] || DEFAULT_UNKNOWN_STATE
    end
  end

  def mapeo_list
    if mapeo == DEFAULT_MAPEO_NAME && DEFAULT_MAPEOS[saludmax]
      DEFAULT_MAPEOS[saludmax]
    else
      str_mapeo_to_list(mapeo)
    end
  end

end
