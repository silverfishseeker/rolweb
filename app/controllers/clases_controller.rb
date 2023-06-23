class ClasesController < ApplicationController
    def index
        @clases = Clase.all
    end

    def show
        @clase = Clase.find(params[:id])
    end

    def new
      @clase = Clase.new
    end
  
    def create
      @clase = Clase.new(clase_params)
  
      if @clase.save
        redirect_to @clase
      else
        render :new, status: :unprocessable_entity
      end
    end

  private
    def clase_params
      params.require(:clase).permit(:efecto, :descripcion, :nombre, :nivel)
    end
end
