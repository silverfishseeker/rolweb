class ContextolootsController < ModelController
  
  include AdminAccess
  restrict_admin_access

  def tipo; Contextoloot end

  def model_params
    params.require(:contextoloot).permit(:nombre, item_ids: [], categ_ids: [])
  end
end
