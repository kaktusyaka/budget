FactoryGirl.define do
  factory :contact_us do
    email   { Faker::Internet.email }
    name    { Faker::Name.first_name }
    subject { Faker::Lorem.word }
    body    { Faker::Lorem.paragraph }
  end
end
