module AccessControl
  extend ActiveSupport::Concern

  LEVELS_NAMES = [
    "Súperadministrador", # 0
    "Administrador",      # 1
    "Game Master",        # 2
    "Jugador",            # 3
    "Sin registrar"       # 4
  ].freeze

  LVS = {
    superadmin: 0,
    admin: 1,
    master: 2,
    player: 3,
    unlogged: 4
  }.freeze

  included do
    before_action :_apply_access_control, unless: :devise_controller?
    class_attribute :_access_rules, default: {}
  end

  def self.check_level!(level)
    raise ArgumentError, "Level debe ser un Symbol." unless level.is_a?(Symbol)
    raise ArgumentError, "Nivel no existente." unless LVS.key?(level)
  end

  def has_level?(level=:admin)
    AccessControl.check_level! level
    curr_level = session[:admin].present? ? LVS[:superadmin] : (current_user&.rango || LVS[:unlogged])
    curr_level <= LVS[level]
  end

  def require_level(level=:admin, message = nil)
    return true if has_level?(level)
    flash[:alert] = message || "No tienes suficientes permisos para ver esta página o realizar esta acción."
    if level == :superadmin
      session[:return_to] = request.fullpath
      redirect_to new_adminsession_path
    else
      redirect_back(fallback_location: root_path)
    end
    false
  end

  def _apply_access_control
    rules = self.class._access_rules
    require_level(rules[action_name.to_sym] || rules[:all] || :admin)
  end

  class_methods do
    def configure_access(*actions, level: :admin)
      AccessControl.check_level! level
      self._access_rules = _access_rules.dup
      actions = [:all] if actions.empty?
      actions.each do |action|
        _access_rules[action.to_sym] = level
      end
    end
  end

end
