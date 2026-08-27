class PersonajegroupsController < ModelController
  include UnlimitedCache

  configure_access level: :master
  after_action only: %i[create update destroy] do
    cache_delete "#{current_user.id}_personajegroups" if user_signed_in?
  end

  def tipo; Personajegroup end

  def model_params
    params.require(:personajegroup).permit(:nombre, personajes_ids: [], user_ids: [])
  end

  before_action :check_ownership, only: [:show, :edit, :destroy]
  
  def check_ownership
    require_level(:admin) || @x.users.exists?(current_user.id)
  end

  def create
    super do
      @x.users << current_user if user_signed_in?
      nil
    end
  end

  def index
    @xs = current_user&.personajegroups || []
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
