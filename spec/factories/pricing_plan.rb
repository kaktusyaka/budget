FactoryGirl.define do
  factory :pricing_plan do
    name                     "Free"
    price                    0.0
    quantity_of_categories   5
    quantity_of_transactions 30
  end

  factory :standart_plan, parent: :pricing_plan do
    name                     "Standart"
    price                    20.0
    quantity_of_categories   1000
    quantity_of_transactions 1000
  end

end
