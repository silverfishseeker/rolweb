class PersonajesController < ModelController
  def tipo; Personaje end
  
  def model_params
      params.require(:personaje).permit(:nombre, :used_id)
  end
end
