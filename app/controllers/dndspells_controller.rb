class DndspellsController < ApplicationController
  
  def initialize
    super
    @as = MydndapiService.new
  end

  def index
    @xs = @as.get('spells').map do |spell| 
      @as.get("spells/#{spell["id"]}") 
    end
  end

  def reset
    @as.get('reset')
    index
  end

  def show
    @x = @as.get("spells/#{params[:id]}")
  end

  def new
    @x = @tipo.new
  end

  def create
    @x = @tipo.new(model_params)

    if @x.save
      redirect_to @x
    else
      redirect_to "/control" , notice: 'La jodiste.'
    end
  end

  def edit
    @x = @tipo.find(params[:id])
  end

  def update
    p(@x)
    @x = @tipo.find(params[:id])

    if @x.update(model_params)
      redirect_to @x
    else
      render :edit
    end
  end

  def destroy
    @x = @tipo.find(params[:id])
    @x.destroy

    redirect_to @tipo
  end
end
