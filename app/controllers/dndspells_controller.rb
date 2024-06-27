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
    @as.get('reset', timeout: 600)
    index
  end

  def show
    @x = @as.get("spells/#{params[:id]}")
  end

  def edit
    show
    @clases = @as.get("clases") 
    @magicschools = @as.get("magicschools") 
  end

  def error
  end

  def update
    @x = @as.put("spells/#{params[:id]}", params)
    if @x
      redirect_to @x
    else
      flash.now[:error] = @x || "Null response"
      render :error, status: :unprocessable_entity
    end
  end

  def destroy
    @x = @as.delete("spells/#{params[:id]}")
    redirect_to dndspells_path
  end

end
