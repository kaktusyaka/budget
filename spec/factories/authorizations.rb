FactoryGirl.define do
  factory :authorization_with_facebook do
    uid      { Faker::Number.number(16) }
    provider "facebook"
    user
  end

  factory :authorization_with_twitter do
    uid      { Faker::Number.number(16) }
    provider "twitter"
    user
  end
end
