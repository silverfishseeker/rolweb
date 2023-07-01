class PicturesController < ModelController

    def initialize
      super 
      @tipo = Picture
    end

    def model_params
      params.require(:picture).permit(:nombre, :image)
    end
end
