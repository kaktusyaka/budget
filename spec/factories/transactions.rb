FactoryGirl.define do
  factory :transaction do
    income      { false }
    date        { Faker::Date.backward(1) }
    amount      { Faker::Number.decimal(1) }
    description { Faker::Lorem.paragraph }
    category
  end

end
