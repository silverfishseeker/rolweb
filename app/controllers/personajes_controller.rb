class PersonajesController < ModelController
  include UnlimitedCache

  def tipo; Personaje end

  def model_params
    params.require(:personaje).permit(
      :nombre, :is_public, :nivel_clases, :nivel_habilidades,
      :nivel_estadisticas, :nivel_otro, :picture_id, :descripcion,
      :descripcion2, :oro, :personajegroup_id, :user_id, cuento_ids: [])
  end

  configure_access level: :player
  configure_access :index, level: :unlogged
  before_action :set, only: %i[
    show edit destroy add_to_personaje add_items_to_personaje update_field
  ]
  before_action :check_ownership, only: %i[
    show edit destroy update_field
  ]
  after_action only: %i[create update destroy] do
    cache_delete "#{current_user.id}_personajes" if user_signed_in?
  end

  def index
    if params[:mode] == "privados"
      return unless require_level :player, "Necesitas crear una cuenta para crear personajes."
      @xs = current_user&.personajes || []
      @header = "Mis personajes"
    else
      @xs = Personaje.where(is_public: true)
      @header = "Personajes públicos"
    end
    @all_pjs = has_level?(:admin) ? Personaje.all : nil
  end

  def new
    # Recover form data from rescue_my_errors redirect
    @x = tipo.new(flash[:form_data] || {})
    @x.build_base_structure
  end

  def create
    super do
      @x.user = current_user if user_signed_in?
      process_associations_for(@x)
    end
  end

  def show
    # Se cargan una sola vez y en la vista se filtran/agrupan en memoria (antes se
    # repetía la misma consulta con distintos where para cada pestaña/sección).
    @personaje_has_habilidads = @x.personajeHasHabilidads.includes(habilidad: [:categs, :mobs, :rich_text_efecto]).order(:position)
    @personaje_has_items = @x.personajeHasItems.includes(item: [:categs, :clases, :rich_text_efecto]).order(:position)
  end

  def edit
    @show_user = has_level?(:admin)
  end

  def update
    super do
      raise "No tienes permiso para editar este personaje." unless check_ownership
      process_associations_for(@x)
      edit_personaje_path(@x) if params[:go_to_edit]
    end
  end

  def check_ownership
    (@x.user == current_user) ||  
    (require_level(:master) && 
      @x.personajegroup.present? &&
      @x.personajegroup.users.exists?(current_user&.id) ||
      require_level(:admin)) # Debe de ejecutarse el último porque envía redireccón al fallar
  end

  def add_to_personaje
    add_item(params[:item_id], params[:cantidad].to_i)
    added_response(params[:item_id])
  end

  def add_items_to_personaje
    params[:items].each do |item_id, num|
      add_item(item_id, num.to_i)
    end
    added_response("items")
  end


  # Acciones de guardado automático en el show
  def broadcast_update_div(target, value)
    @x.broadcast_action_to(@x, action: "update_div", target: target, attributes: { value: value }, render: false)
  end

  def broadcast_toggle_class(target, class_name, on) # Note. We may delete this method later if it is only used once. Keep this note until end of development.
    @x.broadcast_action_to(@x, action: "toggle_class", target: target, attributes: { "class-name" => class_name, on: on }, render: false)
  end

  # Único punto de entrada para todos los campos de autoguardado del show.
  # params[:field] identifica qué se actualiza, params[:target_id] el registro afectado
  # (no aplica para "oro", que actúa sobre el propio personaje) y params[:value] el valor nuevo.
  def update_field
    value = params[:value]
    case params[:field]
    when "stat_mod"
      stadistic = @x.estadistics.find(params[:target_id])
      stadistic.modificable.active_mod = value.to_i
      stadistic.save!
      broadcast_update_div("stat-modifier-#{stadistic.id}", stadistic.modificable.active_mod)
      broadcast_update_div("stat-val-#{stadistic.id}", stadistic.value)
      broadcast_update_div("stat-mod-#{stadistic.id}", stadistic.mod_str)

    when "calc_mod"
      calculado = @x.calculados.find(params[:target_id])
      calculado.modificable.active_mod = value.to_i
      calculado.save!
      broadcast_update_div("calc-modifier-#{calculado.id}", calculado.modificable.active_mod)
      broadcast_update_div("calc-val-#{calculado.id}", calculado.value)

    when "calc_rango"
      calculado = @x.calculados.find(params[:target_id])
      calculado.rango.valor = value.to_i
      calculado.save!
      broadcast_update_div("calc-rango-#{calculado.id}", calculado.rango.valor)

    when "pc_mod"
      pc = @x.parteCuerpos.find(params[:target_id])
      pc.modificable.active_mod = value.to_i
      pc.save!
      broadcast_update_div("pcarm-modifier-#{pc.id}", pc.modificable.active_mod)
      broadcast_update_div("pcarm-val-#{pc.id}", pc.modificable.passive_mod + pc.modificable.active_mod)

    when "pc_salud"
      pc = @x.parteCuerpos.find(params[:target_id])
      pc.saludact += value.to_i # aquí "value" es un delta (+1/-1), no un valor absoluto
      pc.save!
      broadcast_update_div("pcsalud-act-#{pc.id}", pc.saludact)
      broadcast_update_div("pcsalud-state-#{pc.id}", pc.state)
      broadcast_update_div("pcsalud-hidden-#{pc.id}", pc.saludact)
      broadcast_toggle_class("pcsalud-row-#{pc.id}", "pjv-var-cuerpo-borrada", pc.saludact <= 0)

    when "oro"
      @x.oro = value.to_f
      @x.save!
      broadcast_update_div("personaje-oro", @x.oro)

    when "contador_base"
      calculado = find_contador(params[:target_id])
      libre = calculado.calculado_libre || calculado.build_calculado_libre
      libre.base = value.to_i
      calculado.save!
      broadcast_update_div("contador-base-#{calculado.id}", calculado.value)

    when "contador_rango"
      calculado = find_contador(params[:target_id])
      calculado.build_rango if calculado.rango.nil?
      calculado.rango.valor = value.to_i
      calculado.save!
      broadcast_update_div("contador-rango-#{calculado.id}", calculado.rango.valor)

    else
      raise ActiveRecord::RecordNotFound, "Campo desconocido: #{params[:field]}"
    end
    head :ok
  end

  private

  # Busca un calculado "contador" (de clase o habilidad) comprobando que pertenece a @x
  def find_contador(calculado_id)
    calculado = Pj::Calculado.find_by(id: calculado_id)
    owner = calculado&.hasCalculados
    valid = case owner
      when Pj::PersonajeHasClase, Pj::PersonajeHasHabilidad
        owner.personaje_id == @x.id
      else
        false
      end
    raise ActiveRecord::RecordNotFound unless valid
    calculado
  end

  def add_item(item_id, cantidad)
    item = Item.find(item_id)
    phi = @x.personajeHasItems.find_by(item_id: item.id)
    if phi
      phi.cantidad += cantidad
      phi.save!
    else
      phi = @x.personajeHasItems.create!(
        item: item,
        cantidad: cantidad,
        isEquipped: false
      )
    end
  end

  def added_response(id)
    render turbo_stream: [
      turbo_stream.replace(
        "add-item-flash-#{id}",
        partial: "items/add_to_personaje_flash",
        locals: { id: id, added: true }
      )
    ]
  end

  def cleanup_estados_alterados(estadosalterados)
    estadosalterados&.each_value_with_object({}) do |attrs, cleaned|
      id = attrs[:estadoalterado_id]
      if !cleaned[id] || attrs[:_destroy] != "1" 
        cleaned[id] = { valor: attrs[:valor], _destroy: attrs[:_destroy] }
      end
    end
  end
  
  # Procesa estados alterados para el personaje o una parte del cuerpo
  def process_estados_alterados(estadosalterados, target)
    return unless estadosalterados
    # En esta función, si en el formulario hay repetidos, se sobreescriben y cuenta el último
    estadosalterados.to_unsafe_h.each_with_object({}) do |(id, attrs), cleaned|
      if attrs[:libre]
        hea = target.hasEstadoalterados.find_by(id: attrs[:id])
        if attrs[:_destroy] == "1"
          hea.destroy if hea
        else
          if !hea
            hea = target.hasEstadoalterados.build
            hea.build_estadoalteradoLibre
          end
          hea.estadoalteradoLibre.contenido = attrs[:libre]
          hea.save!
        end
      else
        id = attrs[:estadoalterado_id]
        if !cleaned[id] || attrs[:_destroy] != "1" 
          cleaned[id] = {
            estadoalterado_id: id,
            valor: attrs[:valor],
            _destroy: attrs[:_destroy]
          }
        end
      end
    end.each_value  do |attrs|
      hea = target.hasEstadoalterados.find_by( estadoalterado_id: attrs[:estadoalterado_id])
      if attrs[:_destroy] == "1"
        hea.destroy if hea
      else
        hea ||= target.hasEstadoalterados.build( estadoalterado_id: attrs[:estadoalterado_id])
        hea.valor = attrs[:valor].to_i if hea.estadoalterado.isNumeric
        hea.save!
      end
    end
  end

  # calculados of personaje_has_clase or personaje_has_habilidad or personaje_has_item
  def process_contadores_for(contadores, target)
    return unless contadores
    contadores.each_value do |attrs|
      contador = target.calculados.find_by(id: attrs[:id].to_i) if attrs[:id]
      if attrs[:_destroy] == "1"
        contador.destroy if contador
      else
        contador ||= target.calculados.build( modificable: Pj::Modificable.new )
        libre = contador.calculado_libre || contador.build_calculado_libre
        libre.nombre = attrs[:nombre] if attrs[:nombre].present?
        libre.base   = attrs[:base].to_i
        if attrs[:rango].present?
          contador.build_rango if contador.rango.nil?
          contador.rango.valor = attrs[:rango]&.to_i || 0
        else
          contador.rango&.destroy
        end
        contador.save!
      end
    end
  end

  # Al elimar o añadir elementos dejamos huecos o encontramos elementos sin position,
  # las recalculamos todas manteniendo el orden anterior y añadiendo los nuevos la principio.
  def recalculate_positions_for(personaje)
    [personaje.personajeHasClases, personaje.personajeHasHabilidads, personaje.personajeHasItems].each do |association|
      association.sort_by { |e| e.position || -Float::INFINITY }.each_with_index do |element, index|
        element.update(position: index)
      end
    end
  end

  # Procesa los parámetros complejos y actualiza/crea asociaciones en @personaje (que ya existe en @x)
  def process_associations_for(personaje)
    raise "Tipo de formulario no reconocido" unless Personaje::FORM_TYPES.values.include?(params[:form_type])
    return unless require_level :player ||
        (require_level :admin if params[:user_id].present? && params[:user_id].to_i != current_user.id)
    if params[:form_type] == Personaje::FORM_TYPES[:edit]
      edit_process_associations_for(personaje)
    else
      show_process_associations_for(personaje)
    end
  end


  def show_process_associations_for(personaje)
    # ESTADISTICAS
    params[:estadistics].each do |id, attrs|
      stat = personaje.estadistics.find(id.to_i)
      stat.modificable.active_mod = attrs[:active_mod].to_i
      stat.save!
    end

    # ESTADO
    params[:calculados].each do |id, attrs|
      calculado = personaje.calculados.find(id.to_i)
      calculado.modificable.active_mod = attrs[:active_mod].to_i
      if attrs[:rango].present?
        calculado.rango.valor = attrs[:rango].to_i
      end
      calculado.save!
    end

    # PARTES DEL CUERPO
    params[:parte_cuerpos].each do |id, attrs|
      pc = personaje.parteCuerpos.find(id.to_i)
      pc.modificable.active_mod = attrs[:active_mod].to_i
      pc.saludact = attrs[:saludact].to_i
      process_estados_alterados attrs[:has_estadoalterados], pc
      pc.save!
    end
    
    # CLASES
    params[:phc]&.each do |id, attrs|
      phc = personaje.personajeHasClases.find(id.to_i)
      phc.position = attrs[:position].to_i
      process_contadores_for attrs[:calculados], phc
      phc.save!
    end

    # HABILIDADES
    params[:phh]&.each do |id, attrs|
      phh = personaje.personajeHasHabilidads.find(id.to_i)
      phh.position = attrs[:position].to_i
      process_contadores_for attrs[:calculados], phh
      phh.save!
    end

    # ITEMS
    params[:phi_iinv]&.each do |id, attrs|
      phi = personaje.personajeHasItems.find(id.to_i)
      equiped_attrs = params.dig(:phi, id)
      if attrs[:_destroy] == "1" || equiped_attrs && equiped_attrs[:_destroy] == "1"
        phi.destroy
        next
      end
      attrs = equiped_attrs || attrs
      phi.position = attrs[:position].to_i
      phi.isEquipped = attrs[:isEquipped] == "1"
      phi.cantidad = attrs[:cantidad].to_i
      process_contadores_for attrs[:calculados], phi
      phi.customitem.nombre = attrs[:customitem] if attrs[:customitem].present?
      phi.save!
    end
    params[:new_custom_item]&.each do |id, attrs|
      next if attrs[:_destroy] == "1"
      phi = personaje.personajeHasItems.build(
        cantidad: attrs[:cantidad].to_i,
        isEquipped: attrs[:isEquipped] == "1",
        item: nil
      )
      phi.build_customitem(nombre: attrs[:customitem])
      phi.save!
    end

    recalculate_positions_for personaje
  end

  def edit_process_associations_for(personaje)
    
    # PICTURE
    if params[:picture].present?
      pic_params = params[:picture]
      picture = personaje.picture || personaje.build_picture
      picture.image = pic_params[:file] if pic_params[:file].present?
      if picture.image.nil?
        picture.destroy if picture.persisted?
        personaje.picture = nil
      else
        picture.nombre =
            pic_params[:nombre].presence ||
            (File.basename(picture.image.nombre.to_s, ".*").presence if picture.image) ||
            "Imagen de #{personaje.nombre}"
        picture.etiquets = Etiquet.find(pic_params[:etiquet_ids].reject(&:blank?))
        picture.save!
      end
    end

    # ESTADISTICAS
    params[:estadistics].each do |tipo_id_str, attrs|
      tipo_id = tipo_id_str.to_i
      stat = personaje.estadistics.find do |s|
        s.tipo_estadistic_id == tipo_id
      end

      if attrs[:apply].present?
        if ! stat
          stat = personaje.estadistics.build(
            modificable: Pj::Modificable.new,
            tipo_estadistic_id: tipo_id)
        end
        stat.base   = attrs[:base].to_i
        stat.lv_mod = attrs[:lv_mod].to_i
        stat.modificable.passive_mod = attrs[:passive_mod].to_i
        stat.modificable.active_mod  = attrs[:active_mod].to_i
      elsif stat
        stat.destroy
      end
    end

    # ESTADO
    params[:calculados].each do |_, attrs|
      calculado =
        if attrs[:id].present?
          personaje.calculados.find_by(id: attrs[:id])
        else
          personaje.calculados.build( modificable: Pj::Modificable.new )
        end

      if attrs[:_destroy] == "1"
        calculado.destroy
        next
      end

      calculado.modificable.passive_mod = attrs[:passive_mod].to_i
      calculado.modificable.active_mod  = attrs[:active_mod].to_i

      isRango = attrs[:rango].present? || attrs[:is_rango]&.to_i == 1

      if isRango
        calculado.build_rango if calculado.rango.nil?
        calculado.rango.valor = attrs[:rango]&.to_i || 0
      else
        calculado.rango&.destroy
      end

      if attrs[:tipo_id].present?
        if isRango
          calculado.rango.tipoRango_id = attrs[:tipo_id].to_i
        else
          calculado.tipoCalculado_id = attrs[:tipo_id].to_i
        end
      end

      if attrs[:nombre].present?
        libre = calculado.calculado_libre || calculado.build_calculado_libre
        libre.nombre = attrs[:nombre]
        libre.base   = attrs[:base].to_i
      else
        calculado.calculado_libre&.destroy
      end

      calculado.save!
    end

    # ESTADOS ALTERADOS
    process_estados_alterados params[:has_estadoalterados], personaje

    # PARTES DEL CUERPO
    params[:parte_cuerpos].each do |_, attrs|
      pc = if attrs[:id].blank?
        pc = personaje.parteCuerpos.build(modificable: Pj::Modificable.new)
        pc.save!(validate: false) # Guardamos sin validar para tener un ID y poder asociar estados alterados
        pc
      else
        personaje.parteCuerpos.find_by(id: attrs[:id])
      end

      if attrs[:_destroy] == "1"
        pc.destroy
        next
      end

      pc.nombre    = attrs[:nombre]
      pc.tipo      = attrs[:tipo].to_i
      pc.saludact  = attrs[:saludact].to_i
      pc.saludmax  = attrs[:saludmax].to_i
      pc.mapeo     = attrs[:isMapeo] == "1" ? attrs[:mapeo] : Pj::ParteCuerpo::DEFAULT_MAPEO_NAME
      pc.modificable.passive_mod = attrs[:passive_mod].to_i
      pc.modificable.active_mod  = attrs[:active_mod].to_i
      # Estados alterados por parte
      process_estados_alterados attrs[:has_estadoalterados], pc
      pc.save!
    end

    # CLASES
    params[:phcs]&.each do |_, attrs|
      clase_id = attrs[:clase_id].to_i
      phc = personaje.personajeHasClases.find_by(clase_id: clase_id)
      if attrs[:_destroy] == "1"
        phc.destroy if phc
      else
          phc ||= personaje.personajeHasClases.build(clase_id: clase_id)
          phc.nivel = attrs[:nivel].to_i
          if phc.clase.efecto == attrs[:sobreescritura]
            phc.sobreescritura = nil
          else
            phc.sobreescritura = attrs[:sobreescritura]
          end
          process_contadores_for attrs[:calculados], phc
          phc.save!
      end
    end

    # HABILIDADES
    phh_hash = {}
    duplicated_habilidad_ids = Set.new
    params[:phhs]&.each do |_, attrs|
      id = attrs[:habilidad_id].to_i
      if phh_hash[id]
        if phh_hash[id][:_destroy] != "1"
          duplicated_habilidad_ids << id
        end
        if attrs[:_destroy] != "1"
          phh_hash[id] = attrs
        end
      else
        phh_hash[id] = attrs
      end
    end

    if duplicated_habilidad_ids.any?
      add_warning "Las siguientes habilidades estaban duplicadas " \
          "y se ha escogido una aleatoriamente, deberías revisarlas: " \
          "#{duplicated_habilidad_ids.map { |id| Habilidad.find(id).nombre }.join(', ')}. "
    end

    phh_hash.each do |id, attrs|
      phh = personaje.personajeHasHabilidads.find_by(habilidad_id: id)
      if attrs[:_destroy] == "1"
        phh.destroy if phh
      else
        phh ||= personaje.personajeHasHabilidads.build(habilidad_id: id)
        phh.clase_id = attrs[:clase_id].to_i
        if phh.habilidad.efecto == attrs[:sobreescritura]
          phh.sobreescritura = nil
        else
          phh.sobreescritura = attrs[:sobreescritura]
        end
        process_contadores_for attrs[:calculados], phh
        phh.save!
      end
    end


    # ITEMS
    phis_hash = {}
    duplicated_item_ids = Set.new
    params[:phis]&.each do |_, attrs|
      id = attrs[:item_id].to_i
      if phis_hash[id]
        if phis_hash[id][:_destroy] != "1"
          duplicated_item_ids << id
        end
        if attrs[:_destroy] != "1"
          phis_hash[id] = attrs
        end
      else
        phis_hash[id] = attrs
      end
    end

    if duplicated_item_ids.any?
      add_warning "Los siguientes items estaban duplicados " \
          "y se ha escogido una aleatoriamente, deberías revisarlos: " \
          "#{duplicated_item_ids.map { |id| Item.find(id).nombre }.join(', ')}. "
    end

    phis_hash.each do |id, attrs|
      phi = personaje.personajeHasItems.find_by(item_id: id)
      if attrs[:_destroy] == "1"
        phi.destroy if phi
      else
        phi ||= personaje.personajeHasItems.build(item_id: id)
        phi.cantidad = attrs[:cantidad].to_i
        phi.isEquipped = attrs[:isEquipped] == "1"
        if phi.item.efecto == attrs[:sobreescritura]
          phi.sobreescritura = nil
        else
          phi.sobreescritura = attrs[:sobreescritura]
        end
        process_contadores_for attrs[:calculados], phi
        phi.save!
      end
    end

    recalculate_positions_for personaje
  end
end
