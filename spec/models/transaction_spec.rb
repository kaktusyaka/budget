require 'rails_helper'

describe Transaction do
  it { should belong_to(:user) }
  it { should belong_to(:category) }

  context 'Validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:category) }
    it { should validate_length_of(:description).is_at_most(65536) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should allow_value( Date.today ).for(:date) }
    it { should validate_timeliness_of :date }
  end

end
