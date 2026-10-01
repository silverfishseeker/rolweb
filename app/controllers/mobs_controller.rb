class MobsController < ModelController
  
  configure_access :index, level: :master

  def tipo; Mob end

  def model_params
      params.require(:mob).permit(
        :nombre, :image, :cuerpo, :estabilidad, :armaduraMagica, :penetracionFisica, :penetracionMagica, :sangre, :descripcion, :oro,
        habilidadsOfMob_ids: [],
        mob_has_items_attributes: [:id, :item_id, :cantidad, :_destroy]
      ).tap do |ps|
        ps[:mob_has_items_attributes]&.each do |_, attrs|
          attrs[:_destroy] = "1" if attrs[:item_id].blank?
        end
      end
  end
end
