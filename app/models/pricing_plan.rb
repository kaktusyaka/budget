class PricingPlan < ActiveRecord::Base
  has_many :users

  with_options presence: true do |p|
    p.validates :name, length: { maximum: 255 }
    p.validates :price, numericality: { greater_than_or_equal_to: 0.0 }
    p.validates :quantity_of_categories, numericality: { greater_than: 0, only_integer: true }
    p.validates :quantity_of_transactions, numericality: { greater_than: 0, only_integer: true }
  end

  def free?
    name.eql?("free")
  end

  def standart?
    name.eql?("standart")
  end
end
