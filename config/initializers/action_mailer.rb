# Used by Devise mailer

Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.mailgun.org",
    port: 587,
    domain: EnvVars["MAILGUN_DOMAIN"],
    user_name: EnvVars["MAILGUN_USER"] + "@" + EnvVars["MAILGUN_DOMAIN"],
    password: EnvVars["MAILGUN_API_KEY"],
    authentication: "plain",
    enable_starttls_auto: true
  }
end