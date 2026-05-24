require "ostruct" # OpenStruct

class SilverImageUploader
  MODES = [:none, :cut_to_fit]

  class_attribute :warn_on_remove_missing, default: true

  def initialize (mode = :none)
    raise "SilverImageUploader: Modo no soportado: #{mode}" if !MODES.include?(mode)
    @mode = mode
    @cache = ImageUploaderConfig.cache_type.get_cache(Image)
  end

  # @return nil if not found
  def get(id)
    return nil if id.blank?
    
    if (c_img = @cache.fetch(id))
      return c_img 
    end

    if u_img = ImageUploaderConfig.uploader.get(id)
      @cache.store(u_img)
      u_img
    else
      OpenStruct.new(id: id, not_found?: true)
    end
  end

  def set(file, old_id)
    raise "SilverImageUploader.set: Nil file when trying to set image" if file.nil?

    file = self.class.to_webp(file, @mode)
    ActiveRecord::Base.transaction do
      remove!(old_id)
      img = ImageUploaderConfig.uploader.add(file)
      @cache.store(img)
      img.id
    end
  end
  
  def remove!(id)
    record = error_coalesce(ArgumentError) {@cache.fetch(id)}
    if record
      @cache.remove(id)
      ImageUploaderConfig.uploader.remove!(record)
    else
      Rails.logger.warn "SilverImageUploader#remove: Se ha intentado eliminar la imagen no existente, id: #{id}" if warn_on_remove_missing
    end
  end

  # This method is only used in backup restore for now.
  # This method does not reset the image field in the record. If it does not point to a image, it should be nil.
  # Thus, you need to take care of it after you run that model. If your record does not point to a valid image,
  # it wonn't break the application, but "imageLoadFail.png" will be shown instead.
  def self.clear_all!
    ImageUploaderConfig.uploader.clear_all!
  end

  private

  require "mini_magick"
  def self.to_webp(file, mode)
    begin
      image = MiniMagick::Image.new(file.tempfile.path)
      image.validate!
    rescue
      raise "SilverImageUploader#to_webp: El archivo subido no es una imagen válida."
    end

    formato = image["%m"].downcase
    
    return file if formato == "gif"
    
    # Recortar imagen a contenido
    was_trimmed = false
    if mode == :cut_to_fit
      old_width, old_height = image.width, image.height
      image.mogrify do |m|
        m.trim
        m.repage.+
      end
      was_trimmed = old_width != image.width or old_height != image.height
    end

    return file if formato == "webp" and !was_trimmed

    # Convertir a webp

    image.format("webp") do |f|
      f.quality Rails.application.config.webp_quality
    end

    tmpfile = Tempfile.new(["converted-", ".webp"], binmode: true)
    image.write(tmpfile.path)

    ActionDispatch::Http::UploadedFile.new(
      filename: "#{File.basename(file.original_filename, '.*')}.webp",
      type: "image/webp",
      tempfile: tmpfile
    )
  end
end