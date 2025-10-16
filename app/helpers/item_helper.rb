module ItemHelper

  def sub_rd(src, propiedades)
    src.each do |rel|
      valor = yield rel
      valor = "#{rel.cantidad}X" + valor if rel.cantidad > 1
      propiedades << valor
    end
  end

  def ritual_description(item)
    return "" unless item.ritual.present?

    propiedades = []
    sub_rd(item.ritual.ritual_nivel_rel_rituals, propiedades) do |rel|
      "nivel#{rel.ritual_nivel.valor}"
    end
    sub_rd(item.ritual.ritual_clase_rel_rituals, propiedades) do |rel|
      rel.ritual_clase.valor
    end
    sub_rd(item.ritual.ritual_coste_rel_rituals, propiedades) do |rel|
      rel.ritual_coste.valor
    end
    "{#{propiedades.join(', ')}} "
  end
end
