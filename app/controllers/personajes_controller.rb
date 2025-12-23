class PersonajesController < ModelController
  def tipo; Personaje end

  def model_params
    params.require(:personaje).permit(:nombre, :is_public, :picture_id, :descripcion)
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

  # Procesa los parámetros complejos y actualiza/crea asociaciones en @personaje (que ya existe en @x)
  def process_associations_for(personaje)
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

    params[:calculados].each do |_, attrs|
      calculado =
        if attrs[:id].present?
          personaje.calculados.find_by(id: attrs[:id])
        else
          personaje.calculados.build(
            modificable: Pj::Modificable.new
          )
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
    end
  end
end
