require 'features/acceptance_helper'

feature 'Update' do
  given(:user) { create(:user, password: '******') }

  scenario 'Update profile with photo' do
    login(user)
    visit '/users/edit'
    attach_file("Photo", "#{Rails.root}/spec/fixtures/images/john_doe.jpg")
    fill_in 'Current password', with: '******'
    click_button 'Update'
    expect(page).to have_content "Your account has been updated successfully."
    page.find('.navbar .navbar-right img')['src'].should have_content '/uploads/photo/file/1/small_john_doe.jpg'
    visit '/users/edit'
    page.find('.form-group img')['src'].should have_content '/uploads/photo/file/1/thumb_john_doe.jpg'
  end
end
