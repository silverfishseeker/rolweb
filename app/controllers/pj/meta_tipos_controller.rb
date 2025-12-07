class Pj::MetaTiposController < ModelController

  def tipo
    Pj::MetaTipo.str_tipo(params[:tipo])
  end

  def model_params
    params.require(tipo.model_name.param_key).permit(:nombre, :clave, :siglas, :orden)
  end
end
