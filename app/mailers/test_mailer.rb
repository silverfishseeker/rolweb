class TestMailer < ApplicationMailer
  def probe_email()
    @time = Time.current
    mail(
      from: "no-reply@#{EnvVars["MAIL_DOMAIN"]}",
      to: "silverfishseeker@gmail.com",
      subject: "Rolweb prueba Mailgun"
    )
  end
end