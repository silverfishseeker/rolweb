module EnvVars

  ALLOWED_VARS = [
    "IMAGE_STORAGE_BACKEND",
    "CACHE_IS_DISK",
    "CACHE_IS_MEMORY",
    "IMAGE_CACHE_MEMORY_SIZE_MB",
    "BACKUP_UPLOAD_MAX_FILE_SIZE_MB",
    "DATABASE_URL"
  ].freeze

  class InvalidEnvVar < StandardError; end

  def self.[](key)
    raise InvalidEnvVar, "key: #{key}" unless ALLOWED_VARS.include?(key)
    ENV[key]
  end

  def self.all 
    envs = {}
    ALLOWED_VARS.each do |key|
      envs[key] = ENV[key]
    end
    envs
  end
end