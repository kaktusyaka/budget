require 'features/acceptance_helper'

feature '#new/#create' do
  background {
    @user = create(:user)
    login(@user)
    create_two_categories (@user)
    visit new_transaction_path
    expect(page).to have_content "New Transaction"
  }

  scenario 'user can create valid transaction', js: true do
    page.execute_script("$('select#transaction_categories').select2('open');")
    page.should have_content(@user.categories.map(&:name).split(/(?=[A-Z])/).join(" "))
    find('.select2-results li:last-child').click
    page.should have_selector(".select2-selection__rendered", text: @user.categories.last.name)
    page.execute_script("$('#transaction_date').val('10/02/2016')")
    fill_in 'Amount', with: 5
    fill_in_wysihtml5('Description', with: 'Some description')
    click_button 'Submit'

    page.should have_content("Transaction was successfully created")
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
    page.should have_content("Category can't be blank")
    @user.transactions.count.should eq(0)
    end
end
