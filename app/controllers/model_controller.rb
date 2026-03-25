# Base class for models controllers. Requires subclasses to define `tipo` and `model_params` methods.
class ModelController < ApplicationController
  ERRORS_JOIN_CHAR = ' | '.freeze

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
    # Recover form data from transaction_and_rescue_errors redirect
    @x = tipo.new(flash[:form_data] || {})
  end

  def create
    transaction_and_rescue_errors(:new, "Error al crear el modelo #{tipo.name}") do
      @x = tipo.new(model_params)
      
      yield if block_given? # Used only by a few controllers for special actions.

      if @x.save
        redirect_to @x, notice: "#{tipo.name} creado correctamente."
      else
        raise @x.errors.full_messages.join(ERRORS_JOIN_CHAR)
      end
    end
  end

  def edit
  end

  def update
    transaction_and_rescue_errors(:edit, "Error al actualizar el modelo #{tipo.name}") do
      @x = tipo.find(params[:id])
      @x.assign_attributes(model_params)
      
      yield if block_given? # Used only by a few controllers for special actions.
      
      if @x.save
        redirect_to @x, notice: "#{tipo.name} actualizado correctamente."
      else
        raise @x.errors.full_messages.join(ERRORS_JOIN_CHAR)
      end
    end
  end

  def destroy
    @x.destroy

    redirect_to tipo
  end

  private

  def transaction_and_rescue_errors(action_to_redirect, error_message_prefix)
    ActiveRecord::Base.transaction do
      begin
        yield
      rescue => e
        error_message = "#{error_message_prefix}: #{e.message}"
        Rails.logger.error error_message
        flash[:alert] = error_message
        flash[:form_data] = params[tipo.model_name.param_key].except(:image)
        redirect_to  action: action_to_redirect, id: params[:id]
      end
    end
  end
end
