require 'features/acceptance_helper'

feature 'Update' do
  background {
    create_logged_in_user
    visit '/users/edit'
  }

  scenario 'profile uploading photo' do
    attach_file("Photo", "#{Rails.root}/spec/fixtures/images/john_doe.jpg")
    click_button 'Update'
    expect(page).to have_content "Your account has been updated successfully."
    page.find('.navbar .navbar-right img')['src'].should have_content '/uploads/photo/file/1/small_john_doe.jpg'
    visit '/users/edit'
    page.find('.form-group img')['src'].should have_content '/uploads/photo/file/1/thumb_john_doe.jpg'
  end

  scenario 'profile adding remote photo url', js: true do
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

  scenario 'profile with invalid data' do
    fill_in 'First name', with: ""
    fill_in 'Last name', with: ""
    fill_in 'Email', with: ""
    click_button 'Update'
    expect(page).to have_content "First name can't be blank"
    expect(page).to have_content "Last name can't be blank"
    expect(page).to have_content "Email can't be blank"
  end
end
