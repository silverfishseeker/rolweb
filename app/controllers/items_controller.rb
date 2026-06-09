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

  configure_access :add_to_personaje, level: :player

  def add_to_personaje
    Rails.logger.debug "add_to_personajeHHHHHHHH"
    item = Item.find(params[:item_id])
    Rails.logger.debug item.nombre
    personaje = current_user.personajes.find(params[:personaje_id])
    phi = personaje.personajeHasItems.find_by(item: item)
    Rails.logger.debug phi&.item&.nombre
    if phi
      phi.cantidad += params[:cantidad].to_i
      phi.save!
    else
      phi = personaje.personajeHasItems.create!(
        item: item,
        cantidad: params[:cantidad].to_i,
        isEquipped: false
      )
    end

    render turbo_stream: [
      turbo_stream.replace(
        "add-item-flash-#{item.id}",
        partial: "items/add_to_personaje_flash",
        locals: { item_id: item.id, added: true }
      )
    ]
  end
end
