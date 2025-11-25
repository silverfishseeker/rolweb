class Ritual::RitualCostesController < ModelController
  def tipo; Ritual::RitualCoste end
  
  def model_params
    params.require(:ritual_ritual_coste).permit(:valor)
  end
end
