module CuentosHelper
  include UnlimitedCache

  SPECIAL_CHARACTER = "_"

  def calculate_cuento(cuento, do_childs = true)
    cuentos = Cuento.where.not(id: cuento.id).where(oculto: false)
        .select(:id, :nombre).map do |c|
      [c.nombre.downcase, c]
    end.to_h

    regex = /\b(#{cuentos.keys.map { |n| Regexp.escape(n) }.join("|")})\b/ix
    
    cuento.childs.clear if do_childs

    html = cuento.texto.body.to_html.gsub(regex) do |match|
      curr_cuento = cuentos[match.downcase]
      cuento.childs << curr_cuento if do_childs && !cuento.childs.include?(curr_cuento)
      match = match[1..-1] if match.starts_with?(SPECIAL_CHARACTER)
      %(<a href="/cuentos/#{curr_cuento.id}">#{match}</a>)
    end.html_safe

    cuento.save! if do_childs && cuento.changed?
    cache_set "cuentos_html_#{cuento.id}", html
    
    html
  end

  def get_cuento_html
    cache_fetch "cuentos_html_#{@x.id}" do
      calculate_cuento(@x, false)
    end
  end
  
  def list_cuentos(oculto)
    @xs.where(oculto: oculto).order(prioridad: :desc, nombre: :asc)
  end


end
