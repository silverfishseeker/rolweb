# lib/image_uploader_config.rb
module ImageUploaderConfig
  def self.configure
    @uploader = case ENV["IMAGE_STORAGE_BACKEND"] || "minio"
    when "database"
      DatabaseImageUploader.new
    when "minio"
      MinioImageUploader.new
    when "carrierwave"
      CarrierWaveImageUploader.new
    else
      raise "Unsupported storage backend"
    end
    
    cacheIsDisk   = (ENV["CACHE_IS_DISK"]   || "true") == "true"
    cacheIsMemory = (ENV["CACHE_IS_MEMORY"] || "true") == "true"
    @cache_type = case [cacheIsDisk, cacheIsMemory]
    when [true, true]
      HybridCache
    when [true, false]
      DiskCache
    when [false, true]
      MemoryCache
    else
      NoneCache
    end

    @memory_size = ENV["IMAGE_CACHE_MEMORY_SIZE_MB"]&.to_i || 50
    if @memory_size <= 0
      Rails.logger.warn "ImageUploaderConfig: Invalid IMAGE_CACHE_MEMORY_SIZE_MB value #{memory_size}, using default 50 MB"
      @memory_size = 50
    end

    Rails.logger.info "ImageUploaderConfig set: backend=#{@uploader}, cache=#{@cache_type}, memory_size=#{@memory_size}MB"
  end

  def self.uploader
    raise "ImageUploaderConfig: Uploader not configured. Call configure first." unless @uploader
    @uploader
  end

  def self.cache_type
    raise "ImageUploaderConfig: Cache type not configured. Call configure first." unless @cache_type
    @cache_type
  end
end
