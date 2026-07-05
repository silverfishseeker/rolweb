class CuentosController < ModelController
  
  configure_access :index

  include UnlimitedCache
  include CuentosHelper

  def tipo; Cuento end

  def create
    super do
      calculate_cuento(@x)
      nil
    end
  end

  def update
    super do
      calculate_cuento(@x)
      nil
    end
  end

  def model_params
    params.require(:cuento).permit(:nombre, :spoilers, :texto, :prioridad, :titulo, :oculto, etiquet_ids: [], picture_ids: [], mob_ids: [])
  end

end
