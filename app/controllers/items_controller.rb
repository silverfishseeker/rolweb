class ItemsController < ModelController

  def tipo; Item end

  def model_params
    params.require(:item).permit(:nombre, :coste, :peso, :efecto, :remove_image, :image, categ_ids: [], clase_ids: [], habilidad_ids: [])
  end
end
