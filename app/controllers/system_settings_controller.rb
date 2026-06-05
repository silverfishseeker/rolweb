# app\controllers\system_settings_controller.rb
class SystemSettingsController < ApplicationController
  def edit
    @setting = SystemSetting.instance
  end

  def update
    @setting = SystemSetting.instance
    @setting.update(setting_params)
    redirect_to edit_system_setting_path, notice: "Actualizado"
  end

  private

  def setting_params
    params.require(:system_setting)
          .permit(:habilidades_independientes_clase_id)
  end
end