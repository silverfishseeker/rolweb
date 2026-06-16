class PersonajegroupsController < ModelController

  configure_access level: :master

  def tipo; Personajegroup end

  def model_params
    params.require(:personajegroup).permit(:nombre, personajes_ids: [], user_ids: [])
  end

  before_action :check_ownership, only: [:show, :edit, :destroy]
  
  def check_ownership
    @x.users.exists?(current_user.id) || require_level(:admin)
  end

  def create
    super do
      @x.users << current_user
      nil
    end
  end

  def index
    @xs = current_user.personajegroups
    @all_gpjs = has_level?(:admin) ? Personajegroup.all : nil
  end

  def update
    super do
      raise "No tienes permiso para editar este grupo de personajes." unless check_ownership
      @x.personajes.where.not(id: Array(params[:personajes_del_grupo])
          .map(&:to_i)).update_all(personajegroup_id: nil)
      nil
    end
  end
end
