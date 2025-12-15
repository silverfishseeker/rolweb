class PersonajesController < ModelController
  def tipo; Personaje end

  def model_params
    params.require(:personaje).permit(:nombre, :is_public, :picture_id, :descripcion)
  end

  def new
    # Recover form data from rescue_my_errors redirect
    @x = tipo.new(flash[:form_data] || {})

    base_stats = ["fuerza", "inteligencia", "destreza", "constitucion", "resistencia", "percepcion"]
    if @x.new_record?
      base_stats.each do |clave|
        tipo_estadistic = Pj::TipoEstadistic.find_by(clave: clave)
        next unless tipo_estadistic
        @x.estadistics.build(
          tipoEstadistic: tipo_estadistic,
          base: 0,
          lv_mod: 0,
          modificable: Pj::Modificable.new(passive_mod: 0, active_mod: 0)
        )
      end
    end

    Rails.logger.debug @x
    @x.estadistics.each do |i|
      Rails.logger.debug i
    end
  end

  def create
    super do
      @x.user = current_user
      process_associations_for(@x)
    end
  end

  def update
    super do
      process_associations_for(@x)
    end
  end

  private

  # Procesa los parámetros complejos y actualiza/crea asociaciones en @personaje (que ya existe en @x)
  def process_associations_for(personaje)
    if params[:estadistics].present?
      params[:estadistics].each do |tipo_id_str, attrs|
        tipo_id = tipo_id_str.to_i
        stat = personaje.estadistics.find do |s|
          s.tipoEstadistic_id == tipo_id
        end

        if attrs[:apply].present?
          if stat
            stat.base   = attrs[:base].to_i
            stat.lv_mod = attrs[:lv_mod].to_i
            stat.modificable.passive_mod = attrs[:passive_mod].to_i
            stat.modificable.active_mod  = attrs[:active_mod].to_i
          else
            personaje.estadistics.build(
              tipoEstadistic_id: tipo_id,
              base: attrs[:base].to_i,
              lv_mod: attrs[:lv_mod].to_i,
              modificable: Pj::Modificable.new(
                passive_mod: attrs[:passive_mod].to_i,
                active_mod: attrs[:active_mod].to_i
              )
            )
          end
        elsif stat
          stat.destroy
        end
      end
    end

    # # calculados
    # if params[:calculados].present?
    #   params[:calculados].each do |tipo_id_str, attrs|
    #     tipo_id = tipo_id_str.to_i
    #     apply = attrs[:apply].present?
    #     existing = personaje.calculados.find_by(tipo_calculado_id: tipo_id)

    #     if apply
    #       val = attrs[:valor].presence
    #       if existing
    #         existing.update(valor: val)
    #       else
    #         personaje.calculados.build(tipo_calculado_id: tipo_id, valor: val)
    #       end

    #       if attrs[:sobreescritura].present?
    #         m = existing&.modificable || personaje.calculados.find_by(tipo_calculado_id: tipo_id)&.build_modificable
    #         if m
    #           m.active_mod = attrs[:sobreescritura]
    #           m.save
    #         else
    #           new_c = personaje.calculados.find_by(tipo_calculado_id: tipo_id)
    #           if new_c
    #             new_m = Pj::Modificable.new(active_mod: attrs[:sobreescritura])
    #             new_c.modificable = new_m
    #           end
    #         end
    #       end
    #     else
    #       existing.destroy if existing
    #     end
    #   end
    # end

    # # rangos
    # if params[:rangos].present?
    #   params[:rangos].each do |tipo_id_str, attrs|
    #     tipo_id = tipo_id_str.to_i
    #     apply = attrs[:apply].present?
    #     existing = personaje.rangos.find_by(tipo_rango_id: tipo_id)

    #     if apply
    #       val = attrs[:valor].presence
    #       if existing
    #         existing.update(valor: val)
    #       else
    #         personaje.rangos.build(tipo_rango_id: tipo_id, valor: val)
    #       end
    #       # sobrescritura similar si precisa (omito detalle idéntico)
    #     else
    #       existing.destroy if existing
    #     end
    #   end
    # end

    # # CLASES Y HABILIDADES
    # # clases_selected[] contiene ids de clases seleccionadas
    # if params[:clases_selected].present?
    #   selected_class_ids = params[:clases_selected].map(&:to_i)

    #   # eliminar PersonajeHasClase no seleccionadas
    #   personaje.personajeHasClases.where.not(clase_id: selected_class_ids).destroy_all

    #   selected_class_ids.each do |cl_id|
    #     phc = personaje.personajeHasClases.find_or_initialize_by(clase_id: cl_id)
    #     # nivel si viene
    #     if params.dig(:clases_data, cl_id.to_s, :nivel).present?
    #       phc.nivel = params[:clases_data][cl_id.to_s][:nivel]
    #     end
    #     phc.save if phc.changed? || phc.new_record?

    #     # habilidades de esa clase seleccionadas
    #     hab_ids = (params.dig(:habilidades_for_clase, cl_id.to_s) || []).map(&:to_i)
    #     # borrar las que no estén
    #     phh_existing_ids = personaje.personajeHasHabilidads.where(personaje_has_clase_id: phc.id).pluck(:habilidad_id)
    #     # Remove those not selected
    #     personaje.personajeHasHabilidads.where(personaje_has_clase_id: phc.id, habilidad_id: phh_existing_ids - hab_ids).destroy_all

    #     hab_ids.each do |hab_id|
    #       # create personajeHasHabilidad if not exists, link to phc
    #       phh = personaje.personajeHasHabilidads.find_or_initialize_by(habilidad_id: hab_id, personaje_id: personaje.id)
    #       phh.personajeHasClase_id = phc.id if phh.respond_to?(:personajeHasClase_id)
    #       phh.save if phh.new_record? || phh.changed?

    #       # sobrescritura de skill específica (si viene)
    #       if params.dig(:habilidades_sobrescritura, cl_id.to_s, hab_id.to_s).present?
    #         # assuming has_rich_text :sobreescritura on Pj::PersonajeHasHabilidad
    #         content = params[:habilidades_sobrescritura][cl_id.to_s][hab_id.to_s]
    #         # create/update rich text
    #         phh.sobreescritura = content
    #         phh.save
    #       end
    #     end
    #   end
    # else
    #   # no se seleccionaron clases -> eliminar todas las PersonajeHasClase y sus PersonajeHasHabilidads
    #   personaje.personajeHasClases.destroy_all
    #   personaje.personajeHasHabilidads.destroy_all
    # end

    # # HABILIDADES INDEPENDIENTES (hab_independent)
    # if params[:hab_independent].present?
    #   params[:hab_independent].each do |hab_id_str, attrs|
    #     hab_id = hab_id_str.to_i
    #     apply = attrs[:apply].present?
    #     phh = personaje.personajeHasHabilidads.find_by(habilidad_id: hab_id, personaje_id: personaje.id)

    #     if apply
    #       unless phh
    #         phh = personaje.personajeHasHabilidads.build(habilidad_id: hab_id)
    #       end
    #       if attrs[:sobreescritura].present?
    #         phh.sobreescritura = attrs[:sobreescritura]
    #       end
    #       phh.save
    #     else
    #       phh.destroy if phh
    #     end
    #   end
    # end

    # # ITEMS
    # if params[:items].present?
    #   params[:items].each do |item_id_str, attrs|
    #     item_id = item_id_str.to_i
    #     apply = attrs[:apply].present?
    #     phi = personaje.PersonajeHasItem.find_by(item_id: item_id)

    #     if apply
    #       cantidad = attrs[:cantidad].presence || 1
    #       if phi
    #         phi.update(cantidad: cantidad)
    #       else
    #         personaje.PersonajeHasItem.build(item_id: item_id, cantidad: cantidad)
    #       end

    #       if attrs[:sobreescritura].present?
    #         phi = personaje.PersonajeHasItem.find_by(item_id: item_id) # fetch the one
    #         if phi
    #           phi.sobreescritura = attrs[:sobreescritura]
    #           phi.save
    #         end
    #       end
    #     else
    #       phi.destroy if phi
    #     end
    #   end
    # end

    # # ESTADOS ALTERADOS
    # if params[:estados].present?
    #   params[:estados].each do |est_id_str, attrs|
    #     est_id = est_id_str.to_i
    #     apply = attrs[:apply].present?
    #     record = personaje.hasEstadoalterados.find_by(estado_alterado_id: est_id)

    #     if apply
    #       valor = attrs[:valor].presence
    #       if record
    #         record.update(valor: valor)
    #       else
    #         personaje.hasEstadoalterados.build(estado_alterado_id: est_id, valor: valor)
    #       end
    #     else
    #       record.destroy if record
    #     end
    #   end
    # end

    # # PARTES DEL CUERPO (solo editar existentes)
    # if params[:partes].present?
    #   params[:partes].each do |parte_id_str, attrs|
    #     parte_id = parte_id_str.to_i
    #     parte = personaje.parteCuerpos.find_by(id: parte_id) # assuming relation name parteCuerpos
    #     if parte
    #       if attrs[:estado].present?
    #         parte.update(saludact: attrs[:estado])
    #       end
    #     end
    #   end
    # end

    # # NOTAS, niveles y otros campos calculados
    # if params[:personaje].present?
    #   # permitir que el usuario envíe notas o niveles adicionales en params[:personaje]
    #   personaje.nivel_clases    = params[:personaje][:nivel_clases] if params[:personaje][:nivel_clases]
    #   personaje.nivel_habilidades = params[:personaje][:nivel_habilidades] if params[:personaje][:nivel_habilidades]
    #   personaje.nivel_estadisticas = params[:personaje][:nivel_estadisticas] if params[:personaje][:nivel_estadisticas]
    #   personaje.nivel_otro = params[:personaje][:nivel_otro] if params[:personaje][:nivel_otro]
    #   personaje.descripcion = params[:personaje][:descripcion] if params[:personaje][:descripcion]
    # end

    # RETURN: we do not save aquí, ModelController lo hará al final del flujo
    true
  end
end
