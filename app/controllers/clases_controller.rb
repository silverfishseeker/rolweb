class ClasesController < ModelController

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
      redirect_to new_clase_path , notice: 'La jodiste.'
    end
  end

  def edit
    @clase = Clase.find(params[:id])
  end

  def update
    @clase = Clase.find(params[:id])

    if @clase.update(clase_params)
      redirect_to @clase
    else
      render :edit
    end
  end

  def destroy
    @clase = Clase.find(params[:id])
    @clase.destroy

    redirect_to clases_path, status: :see_other
  end

  private
    def clase_params
      params.require(:clase).permit(:efecto, :descripcion, :nombre, :nivel, :image)
    end
end
