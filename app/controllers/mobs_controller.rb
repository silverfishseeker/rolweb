class MobsController < ModelController
  
  http_basic_authenticate_with name: "yomismo", password: "yasabess", except: [:show]

  def initialize
    super 
    @tipo = Mob
  end

  def model_params
      params.require(:mob).permit(:nombre, :image, :cuerpo, :estabilidad, :armaduraMagica, :penetracionFisica, :penetracionMagica, :sangre, :descripcion, :oro, item_ids: [], habilidadsOfMob_ids: [])
  end
end
