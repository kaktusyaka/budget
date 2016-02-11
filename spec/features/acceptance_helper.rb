require 'rails_helper'

def create_logged_in_user
  user = create(:user)
  login(user)
  user
end

def login(user)
  login_as user, scope: :user
end

def create_two_categories user
  create(:category, user: user)
  create(:category, user: user)
end

def fill_in_wysihtml5(labl, opts={})
  page.execute_script <<-JAVASCRIPT
      id = $('label:contains("#{labl}")').attr("for");
      $("#" + id).data("wysihtml5").editor.setValue("#{opts[:with]}");
    JAVASCRIPT
end
