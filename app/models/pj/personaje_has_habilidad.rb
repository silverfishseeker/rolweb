class Pj::PersonajeHasHabilidad < ApplicationRecord
  #attributes: (none propias)

  belongs_to :personaje
  belongs_to :habilidad
  belongs_to :clase

  has_many :calculados, as: :hasCalculados, class_name: "Pj::Calculado", dependent: :destroy, autosave: true, inverse_of: :hasCalculados

  has_rich_text :sobreescritura

  scope :ordered, -> { joins(:habilidad).order("habilidads.nivel, habilidads.nombre") }

  include Ordenable
  def ordenado_lists
    [TIPO_TO_LIST.fetch(habilidad.tipo)]
  end
  TIPO_TO_LIST = {
    0 => :activas,
    3 => :activas,
    5 => :activas,
    1 => :pasivas,
    2 => :otras,
    4 => :otras,
    6 => :otras }.freeze
end
