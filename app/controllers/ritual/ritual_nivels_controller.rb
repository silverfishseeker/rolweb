class Ritual::RitualNivelsController < ModelController
  def tipo; Ritual::RitualNivel end

  def model_params
    params.require(:ritual_ritual_nivel).permit(:valor)
  end
end
