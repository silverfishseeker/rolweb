class PersonajesController < ApplicationController
  before_action :set_personaje, only: %i[ show edit update destroy ]

  # GET /personajes or /personajes.json
  def index
    @personajes = Personaje.all
  end

  # GET /personajes/1 or /personajes/1.json
  def show
  end

  # GET /personajes/new
  def new
    @personaje = Personaje.new
  end

  # GET /personajes/1/edit
  def edit
  end

  # POST /personajes or /personajes.json
  def create
    @personaje = Personaje.new(personaje_params)

    respond_to do |format|
      if @personaje.save
        format.html { redirect_to @personaje, notice: "Personaje was successfully created." }
        format.json { render :show, status: :created, location: @personaje }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @personaje.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personajes/1 or /personajes/1.json
  def update
    respond_to do |format|
      if @personaje.update(personaje_params)
        format.html { redirect_to @personaje, notice: "Personaje was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @personaje }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @personaje.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personajes/1 or /personajes/1.json
  def destroy
    @personaje.destroy!

    respond_to do |format|
      format.html { redirect_to personajes_path, notice: "Personaje was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personaje
      @personaje = Personaje.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def personaje_params
      params.expect(personaje: [ :user_id, :nombre ])
    end
end
