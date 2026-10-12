class DocumentosController < ModelController

    configure_access :index

    def tipo; Documento end

    def model_params
      params.require(:documento).permit(:contenido)
    end

end
