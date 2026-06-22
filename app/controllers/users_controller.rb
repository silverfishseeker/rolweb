class UsersController < ModelController

  configure_access # Quitar los permisos de :index, :show de Model controller
  
  def tipo; User end
  
  def model_params
    params.require(:user).permit(:email, :nombre, :password, :password_confirmation, :rango)
  end

  def new
    raise AbstractController::ActionNotFound, "No se permite crear usuarios desde este controlador"
  end

  def create
    raise AbstractController::ActionNotFound, "No se permite crear usuarios desde este controlador"
  end

  def edit
    @ranks = get_LEVELS_NAMES_from :admin
  end

  def update
    super do
      if has_level? :superadmin
        if ! get_level_range_from(:admin).include? @x.rango
          raise "El rango que intentas asignar no está disponible"
        end
      else
        if @x.rango_in_database == AccessControl::LVS[:admin]
          raise "No tienes permiso para editar a otros administradores."
        end
        if ! get_level_range_from(:master).include?(@x.rango)
          raise "No tienes permiso para asignar ese rango."
        end
      end
    end
  end

  def destroy
    if !has_level?(:superadmin) && @x.rango == AccessControl::LVS[:admin]
      raise "No tienes permiso para eliminar a otros administradores."
    end
    @x.destroy

    redirect_to users_path
  end
end