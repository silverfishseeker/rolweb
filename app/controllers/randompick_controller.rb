class RandompickController < ApplicationController
  def lootbox
  end
  
  def lootboxing
    oro = 0
    oromin = params[:oromin].to_i
    objetos = []
    disponibles = Item.joins(:categs).where(categs: { id: params[:categ_ids] }).distinct
    
    if disponibles.empty?
      session[:lootbox] = nil
    else
      rango = 1..params[:copia].to_i
      while oro < oromin do
        objetoRandom = disponibles.sample
        cantidad = rand(rango)
        oro += objetoRandom.coste * cantidad
        objetos << [objetoRandom.id, cantidad]
      end
      
      session[:lootbox] = objetos
    end

    redirect_to "/lootbox"
  end
end
