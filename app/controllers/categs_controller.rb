class CategsController < ModelController
    def tipo; Categ end
  
    def model_params
      params.require(:categ).permit(:nombre, item_ids: [], contextoloot_ids: [])
    end
end