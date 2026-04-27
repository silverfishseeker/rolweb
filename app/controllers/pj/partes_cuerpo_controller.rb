class Pj::PartesCuerpoController < ApplicationController
  def change(value)
    @parte_cuerpo = Pj::ParteCuerpo.find(params[:id])
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