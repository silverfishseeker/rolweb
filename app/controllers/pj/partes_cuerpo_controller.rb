class Pj::PartesCuerpoController < ApplicationController
  def change(value)
    @parte_cuerpo = Pj::ParteCuerpo.find(params[:id])
    @parte_cuerpo.modificable.passive_mod = params[:passive_mod].to_i
    @parte_cuerpo.modificable.active_mod = params[:active_mod].to_i
    @parte_cuerpo.saludact = params[:current].to_i + value
    render turbo_stream: turbo_stream.replace(
      view_context.dom_id(@parte_cuerpo),
      partial: "personajes/show_parte_cuerpo",
      locals: { pc: @parte_cuerpo }
    )
  end

  def aumentar
    change(1)
  end

  def disminuir
    change(-1)
  end
end