module PersonajesHelper
  def ea_t_id(index)
    "ea_table_#{index}"
  end

  def parte_cuerpo_link(pc, type)
    raise "Invalid type: #{type}" unless [:aumentar, :disminuir].include?(type)
    link_to(
      type == :aumentar ? "+" : "-",
      "/pj/partes_cuerpo/#{pc.id}/#{type}?current=#{pc.saludact}",
      data: {
        turbo_frame: dom_id(pc),
        turbo_prefetch: false
      },
      class: "btn btn-small #{type == :aumentar ? 'btn-secondary' : 'btn-danger'}"
    )
  end
end
