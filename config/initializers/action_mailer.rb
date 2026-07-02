# Used by Devise mailer

case EnvVars["MAIL_DELIVERY_METHOD"]
when "smtp"
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
when "mailgun_api"
  require_relative "../../app/mailers/mailgun_delivery"
  ActionMailer::Base.add_delivery_method(
    :mailgun_api,
    MailgunDelivery
  )
  ActionMailer::Base.delivery_method = :mailgun_api
else
  raise "Unknown MAIL_DELIVERY_METHOD: #{EnvVars["MAIL_DELIVERY_METHOD"]}. Supported values: smtp, mailgun_api"
end

# This is for generting URLs within mailers. Needed for devise
ActionMailer::Base.default_url_options = { host: EnvVars["APP_HOST"], port: 80 }