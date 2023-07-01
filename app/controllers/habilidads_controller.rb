class HabilidadsController < ModelController

  def initialize
    super 
    @tipo = Habilidad
  end
  
  def model_params
    params.require(:habilidad).permit(:nombre, :nivel, :efecto, :image, clase_ids: [], item_ids: [])
  end
end
