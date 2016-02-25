class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'

  validates :first_name, :last_name, presence: true, length: { maximum: 255 }
  has_many :authorizations, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :transactions, through: :categories

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  mount_uploader :file, FileUploader

  def self.from_omniauth auth, current_user = nil
    authorization = Authorization.from_omniauth auth
    user = current_user || User.where(({ email: [auth.info.email, self.temp_email(auth.uid, auth.provider)]})).first

    if authorization.user.blank?

      if user.nil?
        user = User.new(
          first_name: auth.extra.raw_info.name.split(/ /).first,
          last_name: auth.extra.raw_info.name.split(/ /).last,
          email:  auth.info.email || self.temp_email(auth.uid, auth.provider),
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

  def self.temp_email( uid, provider )
    "#{TEMP_EMAIL_PREFIX}-#{uid}-#{provider}.com"
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
