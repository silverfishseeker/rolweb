class UsersController < ModelController

  configure_access :dashboard, level: :player
  
  def tipo; User end
  
  def model_params
    params.require(:user).permit(:email, :nombre, :password, :password_confirmation, :rango)
  end

  def new
    @x.rango = AccessControl::LVS[:player]
  end

  def create
    super do
      raise "Rango de nuevo usuario inválido" if @x.rango != AccessControl::LVS[:player]
    end
  end
end