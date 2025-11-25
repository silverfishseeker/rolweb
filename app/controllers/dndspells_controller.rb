class DndspellsController < ApplicationController
  
  include AdminAccess
  restrict_admin_access

  around_action :wrap_with_socket_error

  @@as = MydndapiService.new

  def index
    @xs = @@as.get('spells').map do |spell| 
      @@as.get("spells/#{spell["id"]}") 
    end
  end

  def reset
    @@as.get('reset', timeout: 600)
    flash[:notice] = "Spells reset successfully."
    redirect_to action: :index
  end

  def show
    @x = @@as.get("spells/#{params[:id]}")
  end

  def edit
    show
    @clases = @@as.get("clases") 
    @magicschools = @@as.get("magicschools") 
  end

  def update
    @x = @@as.put("spells/#{params[:id]}", params)
    if @x
      redirect_to @x
    else
      flash.now[:error] = @x || "Null response"
      render :error, status: :unprocessable_entity
    end
  end

  def destroy
    @x = @@as.delete("spells/#{params[:id]}")
    flash[:notice] = "Spell deleted successfully"
    redirect_to action: :index
  end

  def wrap_with_socket_error
    yield
  rescue SocketError, Errno::ECONNREFUSED, MydndapiService::UnexpectedResponseError => e
    name = action_name.humanize
    Rails.logger.error "❌ SocketError in #{name}: #{e.message}"
    flash.now[:error] = "Error de conexión en la función #{name}: #{e.class.name} -- #{e.message}."
    render 'shared/error', status: :service_unavailable
  end

end
