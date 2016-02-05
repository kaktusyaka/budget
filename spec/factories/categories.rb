FactoryGirl.define do
  factory :category do
    name { Faker::Commerce.department }
    user
  end
end
