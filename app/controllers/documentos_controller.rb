class DocumentosController < ModelController

    configure_access level: :superadmin
    configure_access :show, level: :unlogged

    def tipo; Documento end

    def model_params
      params.require(:documento).permit(:contenido)
    end

end
