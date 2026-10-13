# app\controllers\system_settings_controller.rb
class SystemSettingsController < ApplicationController
  include UnlimitedCache

  configure_access level: :superadmin

  def edit
    @setting = SystemSetting.instance
  end

  def update
    @setting = SystemSetting.instance
    @setting.update(setting_params)
    cache_delete "navbar_shared"
    redirect_to edit_system_setting_path, notice: "Actualizado"
  end

  private

  def setting_params
    params.require(:system_setting)
          .permit(:habilidades_independientes_clase_id, :image,
                   :reglas_documento_id, :ayuda_documento_id, :avisolegal_documento_id)
  end
end