class TestMailer < ApplicationMailer
  def probe_email()
    @time = Time.current
    mail(
      from: ActionMailer::Base.smtp_settings[:user_name],
      to: "silverfishseeker@gmail.com",
      subject: "Rolweb prueba Mailgun"
    )
  end
end