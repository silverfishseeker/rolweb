class ItemsController < ModelController

  def initialize
    super 
    @tipo = Item
  end

  
  def index
    if params[:isPeso].present?
      if params[:isPeso] == "t"
        @xs = Item.where(peso: 0)
      elsif params[:isPeso] == "f"
        @xs = Item.where.not(peso: 0)
      end
    else
      super
    end
  end

  def model_params
    params.require(:item).permit(:nombre, :coste, :peso, :efecto, :image, categ_ids: [], clase_ids: [])
  end
end
