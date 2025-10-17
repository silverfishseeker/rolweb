# Base class for models controllers. Requires subclasses to define `tipo` and `model_params` methods.
class ModelController < ApplicationController

  # This is the model class that the controller manages. Must be defined in the subclass.
  def tipo
    raise NotImplementedError, "You must implement tipo in the subclass"
  end

  def model_params
    raise NotImplementedError, "You must implement model_params in the subclass"
  end

  before_action :set, only: %i[show edit destroy]
  
  include AdminAccess
  restrict_admin_access
  allow_public_access_to :index, :show

  def set
    @x = tipo.find(params[:id])
  end
  
  def index
      @xs = tipo.all
  end

  def show
  end

  def new
    # Recover form data from rescue_my_errors redirect
    @x = tipo.new(flash[:form_data] || {})
  end

  def create
    rescue_my_errors :new do
      @x = tipo.new(model_params)
      
      yield if block_given? # For now only used by CuentosController

      if @x.save
        redirect_to @x
      else
        Rails.logger.error "Error al crear el modelo #{tipo.name}: #{@x.errors.full_messages.join(', ')}"
        redirect_to "/control" , alert: "Error al crear el modelo #{tipo.name}."
      end
    end
  end

  def edit
  end

  def update
    rescue_my_errors :edit do
      @x = tipo.find(params[:id])
      
      yield if block_given? # For now only used by CuentosController and HabilidadsController
  
      if @x.update(model_params)
        redirect_to @x
      else
        render :edit
      end
    end
  end

  def destroy
    @x.destroy

    redirect_to tipo
  end

  private

  def rescue_my_errors(action_to_redirect)
    begin
      yield
    rescue SilverImageUploader::BadImageFileError => e
      Rails.logger.warn "BadImageFileError: #{e.message}"
      flash[:alert] = e.message
      flash[:form_data] = params[tipo.model_name.param_key].except(:image)
      redirect_to  action: action_to_redirect, id: params[:id]
    end
  end
end
