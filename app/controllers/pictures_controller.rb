class PicturesController < ModelController

  def tipo; Picture end

  def index
    @xs = Picture.all

    # Filtrado por etiquetas
    if params[:etiquet_ids].present? && params[:etiquet_ids].size > 1
      @xs = @xs.joins(:etiquets)
        .where(etiquets: { id: params[:etiquet_ids] })
        .group('pictures.id')
        .having('COUNT(etiquets.id) = ?', params[:etiquet_ids].size-1)
    end

    @xs = @xs.order(updated_at: :desc).page(params[:page]).per(36) # Número de pictures por página
  end

  def model_params
    params.require(:picture).permit(:nombre, :image, etiquet_ids: [])
  end
end
