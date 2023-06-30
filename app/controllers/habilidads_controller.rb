class HabilidadsController < ApplicationController
  
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
        redirect_to new_habilidad_path , notice: 'La jodiste.'
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

    def habilidadesIndependientes
      @habilidades = Habilidad.left_outer_joins(:items, :clases).where(items: { id: nil }, clases: { id: nil })
    end
  
    private
      def habilidad_params
        params.require(:habilidad).permit(:nombre, :nivel, :efecto, :image, clase_ids: [], item_ids: [])
      end
end
