class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'

  has_many :authorizations, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :transactions, through: :categories
  has_one  :photo, as: :imageable, dependent: :destroy
  belongs_to :pricing_plan

  validates :first_name, :last_name, presence: true, length: { maximum: 255 }
  validates :pricing_plan, presence: true
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }, allow_blank: true

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  accepts_nested_attributes_for :photo, allow_destroy: true, reject_if: ->(attr){ attr['file'].blank? and attr['remote_file_url'].blank? }
  before_validation :set_default_pricing_plan, on: :create

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

  private
  def set_default_pricing_plan
    self.pricing_plan = PricingPlan.first unless pricing_plan
  end
end
