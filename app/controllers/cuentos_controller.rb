class CuentosController < ModelController
  
  configure_access :index

  include UnlimitedCache

  def tipo; Cuento end

  def create
    super {set_cuentos_childs}
  end

  def update
    super {set_cuentos_childs}
  end

  def model_params
    params.require(:cuento).permit(:nombre, :spoilers, :texto, :prioridad, :titulo, etiquet_ids: [], picture_ids: [], mob_ids: [])
  end

  def recalcular_childs
    cuentos_hash, regex = CuentosUtils.cuentos_regex(Cuento, false)

    Cuento.find_each do |cuento|
      cuento.childs.clear
      cuento.texto.body.to_html.scan(regex) do |match|
        referenced = cuentos_hash[match.first.downcase]
        next if referenced == cuento
        cuento.childs << referenced unless cuento.childs.include?(referenced)
      end
      cuento.save! if cuento.changed?
    end
    cache_clear
    redirect_to cuentos_path, notice: "Todos los cuentos recalculados correctamente."
  end

  private
  def set_cuentos_childs
    @x.childs.clear
    cuentos, regex = CuentosUtils.cuentos_regex(Cuento, @x)
    @x.texto.body.to_html.scan(regex) do |match|
      cuento = cuentos[match.first.downcase] 
      @x.childs << cuento unless @x.childs.include?(cuento)
    end
    cache_delete "cuentos_html_#{@x.id}"
  end

end
