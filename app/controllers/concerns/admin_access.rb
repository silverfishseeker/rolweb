module AdminAccess
  extend ActiveSupport::Concern
  LEVELS_NAMES = [
    "Súperadministrador", # 0
    "Administrador",      # 1
    "Game Master",        # 2
    "Jugador",            # 3
    "Espectador"          # 4
  ]
  LVS = {
    superadmin: 0,
    admin: 1,
    master: 2,
    player: 3,
    unlogged: 4
  }

  def min_level(level)
    raise "Nivel no existente." unless LVS.key?(level)
    session[:admin].present? ? 0 : (current_user&.rango || 4) <= LVS[level]
  end

  def require_level!(level, meassage=nil)
    unless min_level(level)
      raise meassage || "No tienes suficientes permisos para realizar esta acción."
    end
  end

  def require_admin
    unless session[:admin]
      session[:return_to] = request.fullpath
      redirect_to new_adminsession_path
    end
  end

  class_methods do
    def restrict_admin_access
      before_action :require_admin
    end

    def allow_public_access_to(*actions)
      skip_before_action :require_admin, only: actions
    end

    def restrict_admin_access_to(*actions)
      before_action :require_admin, only: actions
    end
  end

end
