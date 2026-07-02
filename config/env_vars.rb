require 'dotenv/load'

module EnvVars
  VARS = {
    # "key" => [type, default_value, [allowed_values]]
    # allowed_values is only used for :str type. If it's empty, any value is allowed.
    "DATABASE_URL" =>                   [:str, nil, []],
    "DATABASE_USER" =>                  [:str, nil, []],
    "DATABASE_DATABASE" =>              [:str, nil, []],
    "DATABASE_PASSWORD" =>              [:str, nil, []],
    "APP_HOST" =>                       [:str,  "localhost", []], # Used in emails' content
    "IMAGE_STORAGE_BACKEND" =>          [:str,  "s3", ["database", "local", "s3"]], 
    "CACHE_IS_DISK" =>                  [:bool, true],
    "CACHE_IS_MEMORY" =>                [:bool, true],
    "IMAGE_CACHE_MEMORY_SIZE_MB" =>     [:int,  50],
    "BACKUP_UPLOAD_MAX_FILE_SIZE_MB" => [:int,  10],
    "S3_ENDPOINT" =>                    [:str,  "http://minio:9000", []],
    "S3_ACCESS_KEY_ID" =>               [:str,  "minioaccess", []],
    "S3_SECRET_ACCESS_KEY" =>           [:str,  "miniosecret", []],
    "S3_REGION" =>                      [:str,  "us-east-1", []],
    "S3_BUCKET" =>                      [:str,  "cubo", []],
    "S3_FORCE_PATH_STYLE" =>            [:bool, true],
    "MAIL_DELIVERY_METHOD" =>           [:str, "smtp", ["smtp", "mailgun_api"]], 
    "MAIL_PASSWORD" =>                  [:str,  nil, []], # Required for mail sending
    "MAIL_DOMAIN" =>                    [:str,  nil, []], # Required for mail sending
    "MAIL_USER" =>                      [:str,  nil, []],  # Required for mail sending
    "MAIL_ADDRESS" =>                   [:str,  nil, []],  # Required for mail sending
    "MAILGUN_API_KEY" =>                [:str, nil, []], 
    "MAILGUN_ENDPOINT" =>               [:str, "api.eu.mailgun.net", []],
    "RAILS_MAX_THREADS" =>              [:int, 5],
    "PRODUCTION_LOG_LEVEL" =>           [:str, "info"] # Supported values: "debug", "info", "warn", "error", "fatal", "unknown"
  }.freeze

  # You MUST set these variables in production
  PRODUCTION_REQUIRED_VARS = [
    "DATABASE_URL", # Esta variables se usa en database.yml. No podemos gestionarla aquí pero podemos comprobarla aunque sea posteriomente a su uso.
    "DATABASE_USER",
    "DATABASE_DATABASE",
    "DATABASE_PASSWORD",
    "APP_HOST",
    "S3_ENDPOINT",
    "S3_ACCESS_KEY_ID",
    "S3_SECRET_ACCESS_KEY",
    "S3_BUCKET",
    "MAIL_DELIVERY_METHOD",
    "MAIL_DOMAIN"
  ]

  PRODUCTION_REQUIRED_VARS_SMTP = [
    "MAIL_PASSWORD",
    "MAIL_USER",
    "MAIL_ADDRESS"
  ]

  PRODUCTION_REQUIRED_VARS_MAILGUN = [
    "MAILGUN_API_KEY",
    "MAILGUN_ENDPOINT"
  ]

  def self.check_vars(unset, vars)
    vars.each do |key|
      if self[key].blank?
        unset << key
      end
    end
  end

  def self.check_prodution_vars!
    unset = []
    check_vars unset, PRODUCTION_REQUIRED_VARS
    case  self["MAIL_DELIVERY_METHOD"]
    when  "smtp"
      check_vars unset, PRODUCTION_REQUIRED_VARS_SMTP
    when "mailgun_api"
      check_vars unset, PRODUCTION_REQUIRED_VARS_MAILGUN
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
      if VARS[key][2].any? && !VARS[key][2].include?(ENV[key])
        raise "EnvVars Error: Invalid value for key: #{key}, with value: #{ENV[key]}"
      end
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