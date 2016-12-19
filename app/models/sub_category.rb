class SubCategory < ApplicationRecord
  belongs_to :category

  has_one :photo, as: :imageable, dependent: :destroy

  validates :category, presence: true
  validates :name, presence: true, length: { maximum: 255 }

  default_scope -> { order('name') }

  accepts_nested_attributes_for :photo
end
