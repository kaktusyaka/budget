class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'

  has_many :authorizations, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :transactions, through: :categories
  has_one  :photo, as: :imageable, dependent: :destroy
  belongs_to :pricing_plan

  validates :first_name, :last_name, presence: true, length: { maximum: 255 }
  validates :pricing_plan, presence: true, on: :update
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }, allow_blank: true

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  accepts_nested_attributes_for :photo, allow_destroy: true, reject_if: ->(attr){ attr['file'].blank? and attr['remote_file_url'].blank? }
  after_create :set_default_pricing_plan

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

  def create_stripe_customer stripe_token
    Stripe.api_key = Figaro.env.stripe_api_key

    customer = Stripe::Customer.create email: email, card: stripe_token
    update_column :stripe_id, customer.id
  end

  def pay!(pricing_plan, stripe_token)
    Stripe.api_key = Figaro.env.stripe_api_key
    Stripe::Charge.create(
      amount:      (pricing_plan.price * 100).to_i,
      description: "SaveBudget: for pricing plan #{ pricing_plan.name }",
      currency:    Figaro.env.currency_code.downcase,
      source:      stripe_token
    )
    update_column :pricing_plan_id, pricing_plan.id
  end

  private
  def set_default_pricing_plan( downgrade = false )
    update_column :pricing_plan_id, PricingPlan.defaul_plan.id unless pricing_plan and !downgrade
  end
end
