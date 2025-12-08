# Used by Devise mailer

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: EnvVars["MAIL_ADDRESS"],
  port: 587,
  domain: EnvVars["MAIL_DOMAIN"],
  user_name: EnvVars["MAIL_USER"] + "@" + EnvVars["MAIL_DOMAIN"],
  password: EnvVars["MAIL_PASSWORD"],
  authentication: :login,
  enable_starttls_auto: true
}
  # This is for generting URLs within mailers. Needed for devise
  ActionMailer::Base.default_url_options = { host: EnvVars["APP_HOST"], port: 80 }