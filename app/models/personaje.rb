class Personaje < ApplicationRecord
  # attributes: nombre, nivel_clases, nivel_habilidades, nivel_estadisticas,
  #   nivel_otro, is_public, oro
  has_rich_text :descripcion

  belongs_to :user
  belongs_to :personajegroup, optional: true
  has_one :picture, dependent: :destroy, autosave: true

  has_many :estadistics,
    -> { joins(:tipoEstadistic).order("pj_meta_tipos.orden ASC") }, # scope to order, applied on call
    class_name: "Pj::Estadistic",
    dependent: :destroy, autosave: true
  has_many :calculados, as: :hasCalculados, class_name: "Pj::Calculado", dependent: :destroy, autosave: true, inverse_of: :hasCalculados
  has_many :parteCuerpos, class_name: "Pj::ParteCuerpo", dependent: :destroy, autosave: true
  has_many :hasEstadoalterados, class_name: "Pj::HasEstadoalterado", as: :target, dependent: :destroy, autosave: true
  has_many :personajeHasClases, class_name: "Pj::PersonajeHasClase", dependent: :destroy
  has_many :personajeHasHabilidads, class_name: "Pj::PersonajeHasHabilidad", dependent: :destroy
  has_many :personajeHasItems, class_name: "Pj::PersonajeHasItem", dependent: :destroy

  has_and_belongs_to_many :etiquets
  has_and_belongs_to_many :cuentos
  has_and_belongs_to_many :viewUsers, class_name: "User", join_table: "personajes_users"

  def nivel
    sum_nil nivel_clases, nivel_estadisticas, nivel_habilidades, nivel_otro # sum_nil ignora nils
  end

  def personajeHasHabilidads_by_clase
    personajeHasHabilidads.ordered.includes(habilidad: [:categs, :mobs, :rich_text_efecto]).each_with_object({}) do |phh, hash|
      hash[phh.clase_id] ||= []
      hash[phh.clase_id] << phh
    end
  end

  def personajeHasItem_by_categ
    personajeHasItems.ordered.includes(item: [:categs, :clases, :rich_text_efecto]).each_with_object({}) do |phi, hash|
      next unless phi.item
      phi.item.categs.each do |categ|
        hash[categ.id] ||= []
        hash[categ.id] << phi
      end
    end
  end

  def calc_nivel_clases
    personajeHasClases.sum(&:nivel)
  end

  def calc_nivel_habilidades
    personajeHasHabilidads.sum do |phh|
      if phh.clase_id == SystemSetting.instance.habilidades_independientes_clase_id
        phh.habilidad.nivel
      else 
        1
      end
    end
  end

  def calc_nivel_estadisticas
    estadistics.sum(&:lv_mod)
  end

  def build_base_structure
    self.is_public = true

    base_stats =  ["fuerza", "inteligencia", "destreza", "constitucion", "resistencia", "percepcion"]
    base_calcs =  ["penetracion fisica", "penetracion magica", "precision", "armadura magica"]
    base_rangos = ["estabilidad", "sangre", "peso"]
    base_cuerpo = {
      "Cabeza" => 1,
      "Torso" => 1,
      "Brazo Izquierdo" => 1,
      "Brazo Derecho" => 1,
      "Pierna Izquierda" => 0,
      "Pierna Derecha" => 0,
      "Tronco medio" => 0,
      "Abdomen" => 0
    }

    base_stats.each do |clave|
      tipo_estadistic = Pj::TipoEstadistic.find_by(clave: clave)
      next unless tipo_estadistic
      estadistics.build(
        tipoEstadistic: tipo_estadistic,
        base: 0,
        lv_mod: 0,
        modificable: Pj::Modificable.new(passive_mod: 0, active_mod: 0)
      )
    end
    base_calcs.each do |clave|
      tipo_calculado = Pj::TipoCalculado.find_by(clave: clave)
      next unless tipo_calculado
      calculados.build(
        tipoCalculado: tipo_calculado,
        modificable: Pj::Modificable.new(passive_mod: 0, active_mod: 0)
      )
    end
    base_rangos.each do |clave|
      tipo_rango = Pj::TipoRango.find_by(clave: clave)
      next unless tipo_rango
      calculados.build(
        rango: Pj::Rango.new(
          tipoRango: tipo_rango,
          valor: 0
        ),
        modificable: Pj::Modificable.new(passive_mod: 0, active_mod: 0)
      )
    end
    base_cuerpo.each do |nombre, tipo|
      parteCuerpos.build(
        nombre: nombre,
        tipo: tipo,
        mapeo: Pj::ParteCuerpo::DEFAULT_MAPEO_NAME,
        saludmax: 3,
        saludact: 3,
        modificable: Pj::Modificable.new(passive_mod: 0, active_mod: 0)
      )
    end
  end
end
