require 'dotenv/load'

module EnvVars
  VARS = {
    # "key" => [type, default_value]
    "DATABASE_URL" =>                   [:str, nil],
    "DATABASE_USER" =>                  [:str, nil],
    "DATABASE_DATABASE" =>              [:str, nil],
    "DATABASE_PASSWORD" =>              [:str, nil],
    "APP_HOST" =>                       [:str,  "localhost"], # Used in emails' content
    "IMAGE_STORAGE_BACKEND" =>          [:str,  "minio"], # Options: database, minio, carrierwave
    "CACHE_IS_DISK" =>                  [:bool, true],
    "CACHE_IS_MEMORY" =>                [:bool, true],
    "IMAGE_CACHE_MEMORY_SIZE_MB" =>     [:int,  50],
    "BACKUP_UPLOAD_MAX_FILE_SIZE_MB" => [:int,  10],
    "MINIO_ENDPOINT" =>                 [:str,  "http://minio:9000"],
    "MINIO_ACCESS_KEY_ID" =>            [:str,  "minioaccess"],
    "MINIO_SECRET_ACCESS_KEY" =>        [:str,  "miniosecret"],
    "MINIO_REGION" =>                   [:str,  "us-east-1"],
    "MINIO_BUCKET" =>                   [:str,  "cubo"],
    "MAIL_PASSWORD" =>                  [:str,  nil], # Required for mail sending
    "MAIL_DOMAIN" =>                    [:str,  nil], # Required for mail sending
    "MAIL_USER" =>                      [:str,  nil],  # Required for mail sending
    "MAIL_ADDRESS" =>                   [:str,  nil],  # Required for mail sending
    "RAILS_MAX_THREADS" =>              [:int, 5]
  }.freeze

  # You MUST set these variables in production
  PRODUCTION_REQUIRED_VARS = [
    "DATABASE_URL", # Esta variables se usa en database.yml. No podemos gestionarla aquí pero podemos comprobarla aunque sea posteriomente a su uso.
    "DATABASE_USER",
    "DATABASE_DATABASE",
    "DATABASE_PASSWORD",
    "APP_HOST",
    "MINIO_ENDPOINT",
    "MINIO_ACCESS_KEY_ID",
    "MINIO_SECRET_ACCESS_KEY",
    "MAIL_PASSWORD",
    "MAIL_DOMAIN",
    "MAIL_USER",
    "MAIL_ADDRESS"
  ]

  def self.check_prodution_vars!
    unset = []
    PRODUCTION_REQUIRED_VARS.each do |key|
      if self[key].blank?
        unset << key
      end
    end
    if unset.any?
      raise EnvVarError, "The following environment variables " +
          "are required in production but are not set: #{unset.join(", ")}"
    end
  end
  
  def self.[](key)
    raise "EnvVars Error: Unknown key: #{key}" unless VARS.key?(key)
    return VARS[key][1] if ENV[key].blank?
    case VARS[key][0]
    when :int
      ENV[key].to_i
    when :bool
      case ENV[key].downcase
      when "true", "1", "yes" then true
      when "false", "0", "no" then false
      else
        raise "EnvVars Error: Invalid boolean value for key: #{key}, with value: #{ENV[key]}"
      end
    else
      ENV[key]
    end
  end

  def self.all_raw
    VARS.keys.each_with_object({}) do |key, hash|
      hash[key] = ENV[key]
    end
  end

  def self.all
    VARS.keys.each_with_object({}) do |key, hash|
      hash[key] = self[key]
    end
  end
end