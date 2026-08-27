class CategsController < ModelController
  include UnlimitedCache

  after_action only: %i[create update destroy] do
    cache_delete "navbar_shared"
  end

  def tipo; Categ end

  def model_params
    params.require(:categ).permit(:nombre, item_ids: [], contextoloot_ids: [])
  end
end