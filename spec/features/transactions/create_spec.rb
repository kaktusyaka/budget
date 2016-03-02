require 'features/acceptance_helper'

feature '#new/#create' do
  background {
    @user = create(:user)
    login(@user)
    create_two_categories (@user)
    visit transactions_path
    click_link "New Transaction"
    expect(page).to have_content "New Transaction"
  }

  scenario 'user can create valid transaction', js: true do
    page.execute_script("$('#transaction_category_name').autocomplete('search');")
    page.should have_content(@user.categories.map(&:name).split(/(?=[A-Z])/).join(" "))
    find('.ui-autocomplete li:last-child').click
    find_field('Category name').value.should eq @user.categories.last.name

    page.execute_script("$('#transaction_date').val('10/02/2016')")
    fill_in 'Amount', with: 5
    fill_in_wysihtml5('Description', with: 'Some description')
    click_button 'Submit'

    page.should have_content("Transaction was successfully created")
    page.should have_selector(".datatable table tbody tr td", text: @user.categories.last.name)
    @user.transactions.count.should eq(1)
  end

  scenario 'user can not create invalid transaction' do
    fill_in 'Date', with: ""
    click_button 'Submit'
    page.should have_content("5 errors prohibited this transaction from being saved")
    page.should have_content("Date can't be blank")
    page.should have_content("Date is not a valid date")
    page.should have_content("Amount can't be blank")
    page.should have_content("Amount is not a number")
    page.should have_content("Category name can't be blank")
    @user.transactions.count.should eq(0)
    end
end
