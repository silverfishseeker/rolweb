class PersonajesController < ModelController
  def tipo; Personaje end

  def model_params
    params.require(:personaje).permit(:nombre, :is_public, :picture_id, :descripcion, :oro)
  end

  def new
    # Recover form data from rescue_my_errors redirect
    @x = tipo.new(flash[:form_data] || {})
    @x.build_base_structure
  end

  def create
    super do
      @x.user = current_user
      process_associations_for(@x)
    end
  end

  def update
    @y = tipo.find(params[:id])
    super do
      process_associations_for(@x)
    end
  end

  private

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
    estadosalterados.to_unsafe_h.each_with_object({}) do |(_, attrs), cleaned|
      id = attrs[:estadoalterado_id]
      if !cleaned[id] || attrs[:_destroy] != "1" 
        cleaned[id] = {
          estadoalterado_id: id,
          valor: attrs[:valor],
          _destroy: attrs[:_destroy]
        }
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
        libre.nombre = attrs[:nombre]
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

  # Procesa los parámetros complejos y actualiza/crea asociaciones en @personaje (que ya existe en @x)
  def process_associations_for(personaje)
    raise "Tipo de formulario no reconocido" unless Personaje::FORM_TYPES.include?(params[:form_type])
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

  end

  def edit_process_associations_for(personaje)
    
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
        if phi.item.efecto == attrs[:sobreescritura]
          phi.sobreescritura = nil
        else
          phi.sobreescritura = attrs[:sobreescritura]
        end
        process_contadores_for attrs[:calculados], phi
        phi.save!
      end
    end
  end
end
