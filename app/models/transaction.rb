class Transaction < ActiveRecord::Base
  belongs_to :category
  attr_accessor :category_name, :user_id

  scope :income_amount,       ->{ where(income: true) }
  scope :expenditures_amount, ->{ where(income: false) }

  with_options presence: true do |p|
    p.validates :date, timeliness: { type: :date }
    p.validates :amount, numericality: { greater_than: 0 }
    p.validates :category_name
  end
  validates :income, inclusion: { in: [true, false]}
  validates :description, length: { maximum: 65536 }

  before_save :set_category

  def self.expenditures_this_month (ids)
    self.joins(:category).where(id: ids, date: Time.now.beginning_of_month..Time.now, income: false)
                    .group('categories.name')
                    .sum(:amount).to_a
                    .map{ |t| [t.first, t.last.to_f]}
  end

  def self.current_balance
    all.income_amount.sum(:amount) - all.expenditures_amount.sum(:amount)
  end

  private
  def set_category
    self.category = Category.where({user_id: user_id, name: category_name.capitalize}).first_or_create
  end
end
