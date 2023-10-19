class ModelController < ApplicationController
    
    http_basic_authenticate_with name: "yomismo", password: "yasabess", except: [:index, :show]
    
    def index
        @xs = @tipo.all
    end
  
    def show
        @x = @tipo.find(params[:id])
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
  
      redirect_to "/control"
    end
end
