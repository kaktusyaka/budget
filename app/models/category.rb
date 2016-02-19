class Category < ActiveRecord::Base
  belongs_to :user
  has_many :transactions, dependent: :restrict_with_error

  validates :name, uniqueness: { scope: :user_id }, presence: true, length: { maximum: 255 }
  validates :user, presence: true

  default_scope -> { order('position') }
end
