class EtiquetsController < ModelController
  def tipo; Etiquet end

  def model_params
    params.require(:etiquet).permit(:nombre, :color, picture_ids: [])
  end
end
