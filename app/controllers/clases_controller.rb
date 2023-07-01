class ClasesController < ModelController

  def initialize
    super 
    @tipo = Clase
  end

  def model_params
    params.require(:clase).permit(:efecto, :descripcion, :nombre, :nivel, :image)
  end
end
