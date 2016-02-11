FactoryGirl.define do
  factory :category do
    name { Faker::Commerce.department(1) }
    user
  end

  factory :invalid_category, parent: :category do
    name ""
  end
end
