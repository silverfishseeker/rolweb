class Personaje < ApplicationRecord
  # attributes: nombre, nivel_clases, nivel_habilidades, nivel_estadisticas,
  #   nivel_otro, is_public, oro

  PESO_MODIFICADOR_NOMBRE = "Modificador de peso con nombre muy largo para que no se repita con otros items por chorra ya me jodería que se repitiera el nombre de un item y que se jodiera el calculo del peso actual XD"

  Alerta = Struct.new(:nombre, :tipo, :tip) # tipo: :normal o :muerte

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

  def peso_actual
    personajeHasItems.includes(:item, :customitem).sum { |phi| (phi.item&.peso || phi.customitem&.peso || 0) * phi.cantidad }
  end

  def peso_calculado
    calculado_rango("peso")
  end

  def peso_modificador_item
    personajeHasItems.includes(:customitem).find { |phi| phi.customitem&.nombre == PESO_MODIFICADOR_NOMBRE }
  end

  def calculado_rango(clave)
    calculados.find { |c| c.rango&.tipoRango&.clave == clave }
  end

  def alertas
    out = []

    if (sangre = calculado_rango("sangre"))
      if sangre.rango.valor <= 0
        out << Alerta.new("Sangre en 0", :muerte, "Tu sangre ha llegado a 0: debes realizar una tirada de muerte.")
      elsif sangre.rango.valor <= sangre.value / 2.0
        out << Alerta.new("Sangre baja", :normal, "Tu sangre está a la mitad o menos de tu máximo: obtienes desventaja en todas tus tiradas.")
      end
    end

    if (estabilidad = calculado_rango("estabilidad")) && estabilidad.rango.valor <= 0
      out << Alerta.new("Estabilidad en 0", :normal, "Todos los impactos que recibas se consideran críticos y no puedes moverte.")
    end

    if peso_calculado && peso_actual > peso_calculado.value
      out << Alerta.new("Sobrecargado", :normal, "Pierdes estabilidad máxima y el valor de todas tus tiradas físicas por cada unidad de peso que excedas de tu máximo.")
    end

    parteCuerpos.each do |pc|
      if pc.saludact == 0
        out << Alerta.new("#{pc.nombre}: destruido", :muerte, "Debes realizar una tirada de muerte.")
      elsif pc.state == "G"
        out << Alerta.new("#{pc.nombre}: grave", :normal, "No puedes realizar acciones que la involucren; si se daña de nuevo, tirada de muerte (o pierdes la extremidad si es un apéndice).")
      elsif pc.state == "H"
        out << Alerta.new("#{pc.nombre}: herido", :normal, "Las acciones que la involucren obtienen desventaja acumulada por cada extremidad herida. Si te dañan esta parte del cuerpo, desangras.")
      end
    end

    out
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
