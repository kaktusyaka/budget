require 'features/acceptance_helper'

feature '#edit/#update' do
  background {
    @category = create(:category)
    @user = @category.user
    create(:transaction, category_name: @category.name, user_id: @user.id)
    login(@user)
    visit transactions_path
  }

  scenario 'user can update transaction with valid data', js: true do
    page.should have_selector(".datatable table tbody tr td", text: @category.name)
    find("table .open-transaction-js").click()
    expect(page).to have_content "Edit Transaction"

    fill_in 'Amount', with: 50
    click_button 'Submit'

    page.should have_content("Transaction was successfully updated")
    page.should have_selector(".datatable table tbody tr td", text: "$50")
  end
end
