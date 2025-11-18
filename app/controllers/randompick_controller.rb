class RandompickController < ApplicationController
  def lootbox
  end

  BASE = 20.0
  MIN_COEF = 0.051
  def exponentialDistribution(n, baseCoef=1.0)
    n = n.to_f
    baseCoef = baseCoef.to_f

    # la base no puede ser menor que 0
    baseCoef = MIN_COEF if baseCoef < MIN_COEF
    a = BASE*baseCoef

    # Desplazamiendo para que f(0) = 0 , f(1) = n donde las abscisas son rand()
    # rand está definido en [0,1[ por lo que n es el número total de elementos de la lista
    # solve {a^x + y = 0, a^(1 + x) + y = n, a > 0, n > 0, b>0} for {x, y} over the reals 
    x = Math.log(n / (a-1), a)
    y = -n/(a-1)
    return (a**(rand()+x)+y).to_i
  end
  
  def lootboxing
    session[:lootbox_oromin] = params[:oromin]
    session[:lootbox_copia] = params[:copia]
    session[:lootbox_categ_ids] = params[:categ_ids]
    session[:lootbox_contextoloot_ids] = params[:contextoloot_ids]

    oro = 0
    oromin = params[:oromin].to_i
    objetos = []
    disponibles = Item.joins(:categs)
            .where(categs: { id: params[:categ_ids] })
            .where(
              "EXISTS (
                 SELECT 1
                 FROM contextoloots_items cti
                 WHERE cti.item_id = items.id
                   AND cti.contextoloot_id IN (?)
               )
               OR
               (items.usecategloot = true AND EXISTS (
                 SELECT 1
                 FROM categs_contextoloots cci
                 WHERE cci.categ_id = categs_items.categ_id
                   AND cci.contextoloot_id IN (?)
               ))",
               params[:contextoloot_ids], params[:contextoloot_ids]
            ).distinct.order(:coste).to_a

    if disponibles.empty?
      session[:lootbox] = nil
    else
      copia=params[:copia].to_i
      while oro < oromin && !disponibles.empty? do
        objetoRandom = disponibles.delete_at exponentialDistribution(disponibles.length)
        cantidad = exponentialDistribution(copia, objetoRandom.coste) + 1
        oro += (objetoRandom.coste || 0) * cantidad
        objetos << [objetoRandom.id, cantidad]
      end
      
      session[:lootbox] = objetos
    end

    redirect_to "/lootbox"
  end
end
