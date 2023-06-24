class HabilidadsController < ApplicationController

    http_basic_authenticate_with name: "yomismo", password: "yasabes", except: [:index, :show]
  
    def index
        @habilidades = Habilidad.all
    end
  
    def show
        @habilidad = Habilidad.find(params[:id])
    end
  
    def new
      @habilidad = Habilidad.new
    end
  
    def create
      @habilidad = Habilidad.new(habilidad_params)
  
      if @habilidad.save
        redirect_to @habilidad  
      else
        render :new
      end
    end
  
    def edit
      @habilidad = Habilidad.find(params[:id])
    end
  
    def update
      @habilidad = Habilidad.find(params[:id])
  
      if @habilidad.update(habilidad_params)
        redirect_to @habilidad
      else
        render :edit
      end
    end
  
    def destroy
      @habilidad = Habilidad.find(params[:id])
      @habilidad.destroy
  
      redirect_to habilidads_path, status: :see_other
    end
  
    private
      def habilidad_params
        params.require(:habilidad).permit(:nombre, :nivel, :efecto, :image)
      end
end
