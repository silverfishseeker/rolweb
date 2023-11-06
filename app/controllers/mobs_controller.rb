class MobsController < ModelController
  
  def initialize
    super 
    @tipo = Mob
  end

  def model_params
      params.require(:mob).permit(:nombre, :image, :cuerpo, :estabilidad, :armaduraMagica, :penetracionFisica, :penetracionMagica, :sangre, :descripcion, :oro, item_ids: [])
  end
end
