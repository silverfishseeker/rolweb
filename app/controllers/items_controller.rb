class ItemsController < ModelController

  def tipo; Item end

  def new
    super
    @x.usecategloot = true if @x.usecategloot.nil?
  end

  def model_params
    params.require(:item).permit(
      :nombre, 
      :coste, 
      :peso, 
      :efecto, 
      :remove_image, 
      :image, 
      :es_ritual,
      :usecategloot,
      categ_ids: [], 
      clase_ids: [], 
      habilidad_ids: [],
      contextoloot_ids: [],
      ritual_attributes: [
        :id, 
        :_destroy,
        ritual_clase_rel_rituals_attributes: [:id, :ritual_clase_id, :cantidad, :_destroy],
        ritual_coste_rel_rituals_attributes: [:id, :ritual_coste_id, :cantidad, :_destroy],
        ritual_nivel_rel_rituals_attributes: [:id, :ritual_nivel_id, :cantidad, :_destroy]
      ]
    ).tap do |ps|
      Rails.logger.debug "HHHH es_ritual: #{ps[:es_ritual].present?} - #{ps[:es_ritual]}"
      if ps[:es_ritual] == "0"
        ps[:ritual_attributes] = { _destroy: "1", id: error_coalesce{@x.ritual.id}, }
      else
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
end
