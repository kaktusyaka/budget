class ContactUs < ActiveRecord::Base
  validates :email, :name, :subject, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65536 }
end
