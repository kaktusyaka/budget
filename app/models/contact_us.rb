class ContactUs < ActiveRecord::Base
  validates :email, :name, :subject, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65536 }

  after_create :send_message_to_admin

  private
  def send_message_to_admin
    AdminMailer.contact_us(self).deliver
  end

end
