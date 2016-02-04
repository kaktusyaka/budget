require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

def create_logged_in_user
  user = create(:user)
  login(user)
  user
end

def login(user)
  login_as user, scope: :user
end
