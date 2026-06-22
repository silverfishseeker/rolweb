class Pj::MetaTiposController < ModelController

  def tipo
    Pj::MetaTipo.str_tipo(params[:tipo])
  end

  def model_params
    pars = [:nombre, :clave, :siglas, :orden]
    if tipo == Pj::TipoRango || tipo == Pj::TipoCalculado
      pars << :pj_tipo_estadistic_id
    end
    params.require(tipo.model_name.param_key).permit(*pars)
  end
end
