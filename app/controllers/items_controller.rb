class ItemsController < ApplicationController

    http_basic_authenticate_with name: "yomismo", password: "yasabes", except: [:index, :show]
  
    def index
        @items = Item.all
    end
  
    def show
        @item = Item.find(params[:id])
    end
  
    def new
      @item = Item.new
    end
  
    def create
      @item = Item.new(item_params)
  
      if @item.save
        redirect_to @item  
      else
        redirect_to new_item_path , notice: 'La jodiste.'
      end
    end
  
    def edit
      @item = Item.find(params[:id])
    end
  
    def update
      @item = Item.find(params[:id])
  
      if @item.update(item_params)
        redirect_to @item
      else
        render :edit
      end
    end
  
    def destroy
      @item = Item.find(params[:id])
      @item.destroy
  
      redirect_to habilidads_path, status: :see_other
    end
  
    private
      def item_params
        params.require(:item).permit(:nombre, :coste, :peso, :efecto, :image, clase_ids: [])
      end
end
