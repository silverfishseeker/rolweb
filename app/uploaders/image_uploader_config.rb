# lib/image_uploader_config.rb
module ImageUploaderConfig
  def self.uploader
    @uploader ||= case Rails.application.config.image_storage_backend
    when :database
      DatabaseImageUploader.new
    when :minio
      MinioImageUploader.new
    else
      raise "Unsupported storage backend"
    end
  end

  def self.cache_type
    @cache_type ||= case Rails.application.config.image_upload_cache
    when :hybrid
      HybridCache
    when :disk
      DiskCache
    when :none
      NoneCache
    else
      raise "Unsupported cache type"
    end
  end
end
