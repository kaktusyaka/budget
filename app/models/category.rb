class Category < ActiveRecord::Base
  belongs_to :user

  has_many :transactions, dependent: :restrict_with_error
  has_many :sub_categories, dependent: :destroy

  has_one :photo, as: :imageable, dependent: :destroy

  validates :name, uniqueness: { scope: :user_id }, presence: true, length: { maximum: 255 }
  # validates :user, presence: true

  default_scope -> { order('name') }

  accepts_nested_attributes_for :photo
end
