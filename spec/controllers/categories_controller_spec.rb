require 'rails_helper'

describe CategoriesController do
  let(:user) { create(:user) }
  before     { sign_in(user) }

  describe "GET /index" do
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

  describe "POST /create" do

    context "with valid attributes" do
      it "creates new category" do
        expect {
          post :create, category: attributes_for(:category, user_id: user.id)
        }.to change(Category, :count).by(1)
      end

      it "redirects to a new category" do
        post :create, category: attributes_for(:category, user_id: user.id)

        expect(response).to redirect_to Category.last
      end
    end

    context "with invalid attributes" do
      it "does not save new category" do
        expect {
          post :create, category: attributes_for(:invalid_category, user_id: user.id)
        }.to_not change(Category, :count)
      end

      it "re-render new method" do
        post :create, category: attributes_for(:invalid_category, user_id: user.id)

        expect(response).to render_template :new
      end
    end
  end
end

