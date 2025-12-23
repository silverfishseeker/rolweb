class Pj::ParteCuerpo < ApplicationRecord
  #attributes: nombre, tipo, mapeo, saludmax, saludact
  belongs_to :calculado, dependent: :destroy
  belongs_to :modificable, class_name: "Pj::Modificable", foreign_key: "pj_modificable_id", dependent: :destroy, autosave: true
  has_many :hasEstadoalterados
  validate :validate_mapeo

  TIPOS = {
    0 => "Baja",
    1 => "Alta",
    2 => "Muy alta"
  }

  DEFAULT_MAPEOS = {
    1 => ["S"],
    2 => ["G", "S"],
    3 => ["G", "H", "S"],
    4 => ["G", "H", "S", "S+"],
    5 => ["G", "H", "H", "S", "S+"]
  }

  DEFAULT_MAPEO_NAME = "DEFAULT_MAPEO"

  def list_mapeo_to_s list_mapeo
    list_mapeo.join("@")
  end

  def str_mapeo_to_list str_mapeo
    str_mapeo.split("@").map(&:strip)
  end

  def validate_mapeo
    (mapeo == DEFAULT_MAPEO_NAME && DEFAULT_MAPEOS[saludmax]) ||
    str_mapeo_to_list(mapeo).length == saludmax
  end

  def mapeo_list
    if mapeo == DEFAULT_MAPEO_NAME && DEFAULT_MAPEOS[saludmax]
      DEFAULT_MAPEOS[saludmax]
    else
      str_mapeo_to_list(mapeo)
    end
  end

end
