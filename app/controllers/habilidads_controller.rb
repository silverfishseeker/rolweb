class HabilidadsController < ModelController

  def initialize
    super 
    @tipo = Habilidad
  end

  def index
    if params[:mode] == "indep"
      @xs = Habilidad.left_outer_joins(:items, :clases).where(items: { id: nil }, clases: { id: nil })
    elsif params[:mode] == "hidden"
      @xs = Habilidad.unscoped.where(oculto: true)
    else
      super
    end
  end
  
  def model_params
    params.require(:habilidad).permit(:nombre, :nivel, :efecto, :image, :oculto, clase_ids: [], item_ids: [], categ_ids: [], mob_ids: [])
  end
end
