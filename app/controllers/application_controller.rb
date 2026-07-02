include Maintenance

class ApplicationController < ActionController::Base
  include AccessControl
  # Por defecto TODAS las acciones están restringidas a superadmin, hay que especificar
  # las que se quieran permitir a otros usuarios.
  
  def add_warning(message)
    flash[:warning] ||= []
    flash[:warning] << message
  end

  before_action do
    if maintenance_enabled?
      render plain: "Aplicación en mantenimiento. Intente nuevamente más tarde.", status: 503
    end
  end

  rescue_from Net::OpenTimeout do |e|
    Rails.logger.error e.full_message

    redirect_to root_path,
      alert: "No se pudo enviar el correo electrónico. Inténtalo más tarde."
  end
end
