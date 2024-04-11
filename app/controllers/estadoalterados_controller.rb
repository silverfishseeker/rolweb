class EstadoalteradosController < ModelController

    def initialize
      super 
      @tipo = Estadoalterado
    end

    def model_params
      params.require(:estadoalterado).permit(:nombre, :descripcion)
    end
end
