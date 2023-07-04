class HabilidadsController < ModelController

  def initialize
    super 
    @tipo = Habilidad
  end

  def habilidadesIndependientes
    @xs = Habilidad.left_outer_joins(:items, :clases).where(items: { id: nil }, clases: { id: nil })
  end
  
  def model_params
    params.require(:habilidad).permit(:nombre, :nivel, :efecto, :image, clase_ids: [], item_ids: [])
  end
end
