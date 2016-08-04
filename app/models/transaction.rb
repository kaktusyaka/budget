class Transaction < ActiveRecord::Base
  HALF_YEAR = 6
  belongs_to :category
  attr_accessor :category_name, :user_id

  with_options presence: true do |p|
    p.validates :date, timeliness: { type: :date }
    p.validates :amount, numericality: { greater_than: 0 }
    p.validates :category_name
  end
  validates :income, inclusion: { in: [true, false]}
  validates :description, length: { maximum: 65536 }

  scope :income_amount,       ->{ where(income: true) }
  scope :expenditures_amount, ->{ where(income: false) }
  scope :this_month,          ->{ where(date: Date.current.beginning_of_month..Date.current.end_of_month) }
  scope :date_from,           -> (date_from) { where("date >= ?", date_from ) }
  scope :date_to,             -> (date_to)   { where("date <= ?", date_to ) }

  before_save :set_category

  def self.expenditures_this_month (ids)
    self.joins(:category).where(id: ids, income: false).this_month
                    .group('categories.name')
                    .sum(:amount).to_a
                    .map{ |t| [t.first, t.last.to_f]}
  end

  def self.current_balance
    all.income_amount.sum(:amount) - all.expenditures_amount.sum(:amount)
  end

  def self.weekly_balances( month = HALF_YEAR )
    date = (Date.current - month.months).beginning_of_month.beginning_of_week
    data = []
    balance = 0
    while date < Date.current.end_of_month do
      trs = all.where(date: date..date + 6.days)
      dif = trs.current_balance.to_f
      data << [(date + 6.days).strftime("%d.%m"), (dif + balance), (dif + balance)] unless dif.zero?
      balance += dif
      date = date + 7.days
    end
    data
  end

  def self.to_csv
    attributes = %w{ id category_id type date amount description }
    CSV.generate do |csv|
      csv << attributes
      all.each do |transaction|
        csv <<  attributes.map{ |attr| transaction.send(attr) }
      end
    end
  end

  def self.search params

    data = where(nil)

    if params[:search][:value].present?
      data = data.where("categories.name like :search or description like :search", search: "%#{params[:search][:value]}%")
    end

    unless params[:search_by_date_from].blank?
      data = data.date_from(params[:search_by_date_from].to_date)
    end

    unless params[:search_by_date_to].blank?
      data = data.date_to(params[:search_by_date_to].to_date)
    end
    data
  end

  def type
    self.income ? "Income" : "Expenditure"
  end

  private
  def set_category
    self.category = Category.where({user_id: user_id, name: category_name.capitalize}).first_or_create
  end
end
