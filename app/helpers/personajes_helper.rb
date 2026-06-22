module PersonajesHelper
  def ea_t_id(index)
    "ea_table_#{index}"
  end

  def parte_cuerpo_link(pc, type, html_id)
    raise "Invalid type: #{type}" unless [:aumentar, :disminuir].include?(type)
    link_to(
      type == :aumentar ? "+" : "-",
      "/pj/partes_cuerpo/#{pc.id}/#{type}#{compose_get_params({
        current: pc.saludact
      })}",
      data: {
        turbo_frame: "partecuerpo-#{pc.id}_salud",
        turbo_prefetch: false # Evita que el navegador intente cargar el link al hacer hover.
      },
      class: "btn btn-small #{type == :aumentar ? 'btn-secondary' : 'btn-danger'}",
      id: html_id
    )
  end
end
