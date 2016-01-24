class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'

  validates :first_name, :last_name, presence: true, length: { maximum: 255 }
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.from_omniauth auth, current_user = nil
    authorization = Authorization.from_omniauth auth

    if authorization.user.blank?
      user = current_user || User.where('email = ?', auth.info.email).first

      if user.nil?
        user = User.new(
          first_name: auth.extra.raw_info.name.split(/ /).first,
          last_name: auth.extra.raw_info.name.split(/ /).last,
          email:  auth.info.email || "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    if authorization.user != user
      authorization.user = user
      authorization.save!
    end
    authorization.user
  end
end
