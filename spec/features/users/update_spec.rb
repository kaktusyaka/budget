require 'features/acceptance_helper'

feature 'Update' do
  given(:user) { create(:user) }

  scenario 'Update profile upload photo' do
    login(user)
    visit '/users/edit'
    attach_file("Photo", "#{Rails.root}/spec/fixtures/images/john_doe.jpg")
    click_button 'Update'
    expect(page).to have_content "Your account has been updated successfully."
    page.find('.navbar .navbar-right img')['src'].should have_content '/uploads/photo/file/1/small_john_doe.jpg'
    visit '/users/edit'
    page.find('.form-group img')['src'].should have_content '/uploads/photo/file/1/thumb_john_doe.jpg'
  end

  scenario 'Update profile upload photo', js: true do
    login(user)
    visit '/users/edit'
    find('a .glyphicon-link').click
    expect(page).to have_content "Remote photo url"

    image_url = "http://#{Rails.application.config.app_domain}:#{Rails.application.config.app_port}/images/john_doe.jpg"
    stub_request(:get, image_url).to_return(
         :status => 200,
         :body => File.read("spec/fixtures/images/john_doe.jpg"),
         :headers => {}
      )

    fill_in 'Remote photo url', with: image_url
    click_button 'Update'
    expect(page).to have_content "Your account has been updated successfully."
    page.find('.navbar .navbar-right img')['src'].should have_content '/uploads/photo/file/1/small_john_doe.jpg'
    visit '/users/edit'
    page.find('.form-group img')['src'].should have_content '/uploads/photo/file/1/thumb_john_doe.jpg'
  end
end
