require 'rails_helper'

def tw_auth
  return @auth_twitter if @auth_twitter
  @auth_twitter = eval File.read("#{Rails.root}/spec/fixtures/auth_twitter.yml")
end

def fb_auth
  return @auth_facebook if @auth_facebook
  @auth_facebook = eval File.read("#{Rails.root}/spec/fixtures/auth_facebook.yml")
end

describe User do
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:categories).dependent(:destroy) }
  it { should have_many(:transactions).through(:categories) }
  it { should have_one(:photo).dependent(:destroy) }
  it { should accept_nested_attributes_for(:photo).allow_destroy(true) }

 context 'Validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:first_name).is_at_most(255) }
    it { should validate_length_of(:last_name).is_at_most(255) }
  end

 context '#Methods' do
    context '#from_omniauth' do
      context '#login via Twitter without current_user' do
        before { User.from_omniauth( set_omniauth( tw_auth ) ) }

        it 'should create user' do
          expect(User.count).to eq(1)
          expect(Authorization.count).to eq(1)
          expect(Authorization.first.provider).to eq("twitter")
          expect(Authorization.first.uid).to eq(@auth_twitter[:uid])
        end

        it 'should not create existent user' do
          expect{User.from_omniauth( set_omniauth( tw_auth ) )}.to_not change(User, :count)
          expect{User.from_omniauth( set_omniauth( tw_auth ) )}.to_not change(Authorization, :count)
        end
      end

      context '#login via Facebook without current_user' do
        before { User.from_omniauth( set_omniauth( fb_auth ) ) }

        it 'should create user' do
          expect(User.count).to eq(1)
          expect(Authorization.count).to eq(1)
          expect(Authorization.first.provider).to eq("facebook")
          expect(Authorization.first.uid).to eq(@auth_facebook[:uid])
        end

        it 'should not create existent user' do
          expect{User.from_omniauth( set_omniauth( fb_auth ) )}.to_not change(User, :count)
          expect{User.from_omniauth( set_omniauth( fb_auth ) )}.to_not change(Authorization, :count)
          expect("#{User.first.first_name} #{User.first.last_name}").to eq( @auth_facebook[:extra][:raw_info][:name] )
        end
      end

      context 'form Devise' do
        it 'should create new user' do
          current_user = create(:user)
          expect(User.count).to eq(1)
          expect(User.first.first_name).to eq( current_user.first_name )
        end
      end

      context '#login via Facebook with current_user' do
        before{ @current_user = create(:user) }

        it 'should create one more user' do
          expect{User.from_omniauth( set_omniauth( fb_auth ) )}.to change(User, :count)
        end

        it 'should not create existent user' do
          expect{User.from_omniauth( set_omniauth( fb_auth, { info: { email: @current_user.email }} ) )}.to_not change(User, :count)
          expect(User.first.first_name).to eq( @current_user.first_name )
        end
      end

      context '#login via Twitter with current_user' do
        before{ @current_user = create(:user) }

        it 'should create one more user' do
          expect{User.from_omniauth( set_omniauth( tw_auth ) )}.to change(User, :count)
        end

        it 'should not create existent user' do
          expect{User.from_omniauth( set_omniauth( tw_auth, { info: { email: @current_user.email }} ) )}.to_not change(User, :count)
          expect(User.first.first_name).to eq( @current_user.first_name )
        end
      end
    end
  end
end
