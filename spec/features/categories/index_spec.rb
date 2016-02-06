require 'features/acceptance_helper'

feature 'GET #index' do
  given(:user_1) { create(:user) }
  given(:user_2) { create(:user) }

  background {
    @category1 = create(:category, user: user_1)
    @category2 = create(:category, user: user_1)
    @category3 = create(:category, user: user_2)
  }

  scenario 'user can see his categories' do
    login(user_1)
    visit '/categories'
    expect(page).to have_content @category1.name
    expect(page).to have_content @category2.name
  end

  scenario 'user cannot see categories lined to another user' do
    login(user_2)
    visit '/categories'
    expect(page).to_not have_content @category1.name
    expect(page).to_not have_content @category2.name
    expect(page).to have_content @category3.name
  end

  scenario 'user can sort categories', js: true do
    login(user_1)
    visit '/categories'
    page.all("ul li").first.text.should == @category1.name

    src  = find("#category_#{@category1.id}")
    dest = find("#category_#{@category2.id}")
    src.drag_to(dest)
    page.all("ul li").last.text.should == @category1.name
  end
end
