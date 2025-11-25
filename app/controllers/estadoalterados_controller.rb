class EstadoalteradosController < ModelController

    def tipo; Estadoalterado end

    def model_params
      params.require(:estadoalterado).permit(:nombre, :descripcion)
    end
end
