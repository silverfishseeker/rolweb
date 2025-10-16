module ItemHelper
  def ritual_description(item)
    if item.ritual.present?
      propiedades = []

      # Niveles
      item.ritual.ritual_nivel_rel_rituals.each do |rel|
          valor = "nivel#{rel.ritual_nivel.valor}"
          valor += "x#{rel.cantidad}" if rel.cantidad > 1
          propiedades << valor
      end

      # Clases
      item.ritual.ritual_clase_rel_rituals.each do |rel|
          valor = rel.ritual_clase.valor
          valor += "x#{rel.cantidad}" if rel.cantidad > 1
          propiedades << valor
      end

      # Costes
      item.ritual.ritual_coste_rel_rituals.each do |rel|
          valor = rel.ritual_coste.valor
          valor += "x#{rel.cantidad}" if rel.cantidad > 1
          propiedades << valor
      end
        
      "{#{propiedades.join(', ')}} "
    else
      ""
    end
  end
end
