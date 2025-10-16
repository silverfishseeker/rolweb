class ItemsController < ModelController

  def tipo; Item end

  def model_params
    params.require(:item).permit(
      :nombre, 
      :coste, 
      :peso, 
      :efecto, 
      :remove_image, 
      :image, 
      categ_ids: [], 
      clase_ids: [], 
      habilidad_ids: [],
      ritual_attributes: [
        :id, 
        :_destroy,
        ritual_clase_rel_rituals_attributes: [:id, :ritual_clase_id, :cantidad, :_destroy],
        ritual_coste_rel_rituals_attributes: [:id, :ritual_coste_id, :cantidad, :_destroy],
        ritual_nivel_rel_rituals_attributes: [:id, :ritual_nivel_id, :cantidad, :_destroy]
      ]
    ).tap do |ps|
      [
        [:ritual_clase_rel_rituals_attributes, :ritual_clase_id],
        [:ritual_coste_rel_rituals_attributes, :ritual_coste_id],
        [:ritual_nivel_rel_rituals_attributes, :ritual_nivel_id]
      ].each do |array_id, element_id|
        ps[:ritual_attributes][array_id].each do |_, attr|
          attr[:_destroy] = "1" if attr[element_id].blank?
        end
      end
    end
  end
end
