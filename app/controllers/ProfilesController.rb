class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @x = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to dashboard_profile_path, notice: "Perfil actualizado correctamente"
    else
      render :edit
    end
  end

  def confirm_destroy
  end

  private

  def user_params
    params.require(:user).permit(:nombre, :image)
  end
end
