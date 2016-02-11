require 'rails_helper'

describe CategoriesController do
  let(:user) { create(:user) }
  before     { sign_in(user) }

  describe "GET index" do
    it "response successfully with an HTTP status 200" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the categories into @categories" do
      category1, category2 = create(:category, user: user), create(:category, user: user)
      get :index

      expect(assigns(:categories)).to match_array([category1, category2])
    end
  end
end

