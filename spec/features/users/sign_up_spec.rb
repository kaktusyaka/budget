require 'features/acceptance_helper'

feature 'Sign_up', js: true do
  xscenario 'via Twitter', :vcr do
    visit '/users/sign_up'
    expect(page).to have_content 'Sign in with Twitter'
    click_link 'Sign in with Twitter'
    #if has_css?("#oauth_for")
    within("#oauth_form") do
      fill_in 'username_or_email', with: 'nadya.peschanska@mail.ru'
      fill_in 'password', with: 'test11111'
      click_button 'Sign In'
    end
    expect(page).to have_content 'Successfully authenticated from Twitter account'
  end

  xscenario 'via Facebook', :vcr do
    visit '/users/sign_up'
    expect(page).to have_content 'Sign in with Facebook'
    click_link 'Sign in with Facebook'
    within("#login_form") do
      fill_in 'email', with: 'nadya.peschanska@mail.ru'
      fill_in 'password', with: 'test11111'
    end
    click_button 'Log In'
    expect(page).to have_content 'Successfully authenticated from Facebook account'
  end

end
