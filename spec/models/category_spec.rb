require 'rails_helper'

describe Category do
  it { should belong_to(:user) }

  context 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  end
end
