include Maintenance

class ApplicationController < ActionController::Base
  include AccessControl
  # Por defecto TODAS las acciones están restringidas a superadmin, hay que especificar
  # las que se quieran permitir a otros usuarios.
  
  helper_method :warnings
  def add_warning(message)
    flash[:warning] ||= []
    flash[:warning] << message
  end

  before_action :check_maintenance_mode
  def check_maintenance_mode
    if maintenance_enabled?
      render plain: "Aplicación en mantenimiento. Intente nuevamente más tarde.", status: 503
    end
  end
end
