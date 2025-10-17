class Ritual::RitualClasesController < ModelController
  def tipo; Ritual::RitualClase end
  
  def model_params
    params.require(:ritual_ritual_clase).permit(:valor)
  end
end
