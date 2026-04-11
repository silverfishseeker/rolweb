class ApplicationController < ActionController::Base
  helper_method :warnings
  def add_warning(message)
    flash[:warning] ||= []
    flash[:warning] << message
  end
end
