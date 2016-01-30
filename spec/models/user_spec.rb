require 'rails_helper'
require "#{::Rails.root}/spec/fixtures/auth_facebook"

describe User do
  it { should have_many(:authorizations).dependent(:destroy) }

 context 'Validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:first_name).is_at_most(255) }
    it { should validate_length_of(:last_name).is_at_most(255) }
  end

 context '#Methods' do
    context '#from_omniauth' do
      context '#without current_user' do
        it 'should create user via facebook' do
          User.from_omniauth( env["omniauth.auth"] )
          endorsement.update_column :status, 'step_5'
          endorsement.pay!
          endorsement.send(:make_refund!)

          expect(endorsement.refunded_at).to_not be_blank
          expect(endorsement.refund_id).to_not be_blank
        end
      end
    end
  end
end
