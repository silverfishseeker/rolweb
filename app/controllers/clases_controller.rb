class ClasesController < ModelController

  def initialize
    super 
    @tipo = Clase
  end

    # Sobrescribe.
    def index
      if params[:mode] == "raza"
        @xs = Clase.where(oculto:false, raza:true)
        @titulo = "Razas"
      elsif params[:mode] == "radical"
        @xs = Clase.where(oculto:false, radical:true)
        @titulo = "Clases radicales"
      else
        @xs = Clase.where(oculto:false)
        @titulo = "Todas las clases"
      end
      @xs = @xs.sort_by(&:nombre)
    end

  def model_params
    params.require(:clase).permit(:efecto, :descripcion, :nombre, :image, :oculto, :raza, :radical, parent_ids: [], child_ids: [], categ_ids: [])
  end
end
