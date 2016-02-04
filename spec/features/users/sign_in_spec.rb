require 'features/acceptance_helper'

feature 'Sign in' do
  given(:user) { create(:user, email: 'user@example.com', password: 'test111') }

  scenario 'Signing in with correct credentials' do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  scenario "Signing in with incorrect credentials" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '******'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Invalid email or password'
  end
end
