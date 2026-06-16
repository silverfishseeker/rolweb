class Pj::PartesCuerpoController < ApplicationController

  configure_access level: :player

  def change(value)
    @parte_cuerpo = Pj::ParteCuerpo.find(params[:id])
    @parte_cuerpo.saludact = params[:current].to_i + value
    render partial: "personajes/show_salud", locals: {pc: @parte_cuerpo}
  end

  def aumentar
    change(1)
  end

  def disminuir
    change(-1)
  end
end