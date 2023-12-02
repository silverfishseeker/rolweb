class ItemsController < ModelController

  def initialize
    super 
    @tipo = Item
  end

  def model_params
    params.require(:item).permit(:nombre, :coste, :peso, :efecto, :image, categ_ids: [], clase_ids: [], habilidad_ids: [])
  end
end
