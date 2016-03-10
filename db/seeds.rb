# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
[ { name: "free", price: 0.0, quantity_of_categories: 5, quantity_of_transactions: 30 },
  { name: "standart", price: 20.0, quantity_of_categories: 1000, quantity_of_transactions: 1000 }].each do |attributes|

  pricing_plan = PricingPlan.where(attributes).first_or_create
  puts "Error creating pricing plan #{pricing_plan.name}: #{pricing_plan.errors.full_messages.join(", ")}" if pricing_plan.new_record?
end
User.find_each { |u| u.pricing_plan = PricingPlan.first if u.pricing_plan.blank? }

