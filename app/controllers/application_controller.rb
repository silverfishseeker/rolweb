include Maintenance

class ApplicationController < ActionController::Base
  helper_method :warnings
  def add_warning(message)
    flash[:warning] ||= []
    flash[:warning] << message
  end

  before_action :check_maintenance_mode
  def check_maintenance_mode
    if maintenance_enabled?
      render plain: "Aplicación en mantenimiento", status: 503
    end
  end
end
