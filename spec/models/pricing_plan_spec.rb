require 'rails_helper'

describe PricingPlan do
  it { should have_many(:users) }

  context 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:quantity_of_categories) }
    it { should validate_presence_of(:quantity_of_transactions) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0.0) }
    it { should validate_numericality_of(:quantity_of_categories).is_greater_than(0) }
    it { should validate_numericality_of(:quantity_of_transactions).is_greater_than(0) }
    it { should validate_length_of(:name).is_at_most(255) }
  end
end
