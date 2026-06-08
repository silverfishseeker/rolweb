class MobsController < ModelController
  
  configure_access :index, level: :master

  def tipo; Mob end

  def model_params
      params.require(:mob).permit(:nombre, :image, :cuerpo, :estabilidad, :armaduraMagica, :penetracionFisica, :penetracionMagica, :sangre, :descripcion, :oro, item_ids: [], habilidadsOfMob_ids: [])
  end
end
