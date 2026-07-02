require "mailgun-ruby"

class MailgunDelivery
  def initialize(_options)
    @client = Mailgun::Client.new(
      EnvVars["MAILGUN_API_KEY"],
      EnvVars["MAILGUN_ENDPOINT"]
    )
  end


  def deliver!(mail)
    @client.send_message(
      EnvVars["MAIL_DOMAIN"],
      {
        from: mail[:from].to_s,
        to: mail.to.join(","),
        subject: mail.subject,
        html: mail.body.decoded
      }
    )
  end
end