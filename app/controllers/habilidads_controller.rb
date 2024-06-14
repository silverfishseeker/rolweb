class HabilidadsController < ModelController

  def initialize
    super 
    @tipo = Habilidad
  end

  # Realmente estos accesos no están protegidos, cualquiera con la url se puede meter, pero sólo puedes conseguir la url autentifícándote en admin_controller
  # Sobrescribe.
  def index
    if params[:mode] == "sueltas"
      @xs = Habilidad.hide.left_outer_joins(:items, :clases).where(items: { id: nil }, clases: { id: nil })
    else
      if params[:mode] == "hidden"
        @secreto = true
      end
      super
    end
  end

  def new
    @x = @tipo.new
    if params.key?(:newdndspell)
      @x.nombre = params[:name]
      @x.nivel = params[:level]
      @x.efecto = params[:desc]
      @dndClases = params[:clases]
    end
  end

  def model_params
    params.require(:habilidad).permit(:nombre, :nivel, :efecto, :oculto, clase_ids: [], item_ids: [], categ_ids: [], mob_ids: [],mobsHasHabil_ids: [])
  end
end
