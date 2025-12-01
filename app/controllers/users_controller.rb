class UsersController < ModelController

  restrict_admin_access
  allow_public_access_to :dashboard 
  
  def tipo; User end
  
  def model_params
    params.require(:user).permit(:email, :nombre, :password, :password_confirmation, :rango)
  end

  def dashboard
    if !user_signed_in?
      redirect_to new_user_session_path, notice: "No se ha iniciado sesión."
    end
    @x = current_user
  end
end