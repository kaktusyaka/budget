class Transaction < ActiveRecord::Base
  belongs_to :category

  scope :expenditures_this_month, ->(ids) do
    joins(:category).where(id: ids, date: Time.now.beginning_of_month..Time.now, income: false)
                    .group('categories.name')
                    .sum(:amount)
  end

  with_options presence: true do |p|
    p.validates :date, timeliness: { type: :date }
    p.validates :amount, numericality: { greater_than: 0 }
    #p.validates :user
    p.validates :category
  end
  validates :income, inclusion: { in: [true, false]}
  validates :description, length: { maximum: 65536 }
end
