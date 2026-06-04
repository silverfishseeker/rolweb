class PersonajegroupsController < ModelController

  def tipo; Personajegroup end

  def model_params
    params.require(:personajegroup).permit(:nombre)
  end
end
