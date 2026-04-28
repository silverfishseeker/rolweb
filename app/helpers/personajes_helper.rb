module PersonajesHelper
  def ea_t_id(index)
    "ea_table_#{index}"
  end

  def parte_cuerpo_link(pc, type, html_id)
    raise "Invalid type: #{type}" unless [:aumentar, :disminuir].include?(type)
    link_to(
      type == :aumentar ? "+" : "-",
      "/pj/partes_cuerpo/#{pc.id}/#{type}#{compose_get_params({
        current: pc.saludact,
        passive_mod: pc.modificable.passive_mod,
        active_mod: pc.modificable.active_mod
      })}",
      data: {
        turbo_frame: dom_id(pc),
        turbo_prefetch: false
      },
      class: "btn btn-small #{type == :aumentar ? 'btn-secondary' : 'btn-danger'}",
      id: html_id
    )
  end
end
