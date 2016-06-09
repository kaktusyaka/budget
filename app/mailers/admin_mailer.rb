class AdminMailer < ApplicationMailer
  def contact_us data
    @contact_us = data
    mail to: Figaro.env.admin_email, subject: "Request from Contact Us form"
  end
end
