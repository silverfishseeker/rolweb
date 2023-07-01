class ItemsController < ModelController

    def initialize
      super 
      @tipo = Item
    end

    def model_params
      params.require(:item).permit(:nombre, :coste, :peso, :efecto, :image, clase_ids: [])
    end
end
