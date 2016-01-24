class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :uid, uniqueness: { scope: :provider }, presence: true
  validates :provider, presence: true

  def self.from_omniauth auth
    find_or_create_by( uid: auth.uid, provider: auth.provider )
  end
end
