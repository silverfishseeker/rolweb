class CategsController < ModelController

    def initialize
      super 
      @tipo = Categ
    end
  
    def model_params
      params.require(:categ).permit(:nombre, item_ids: [])
    end
end