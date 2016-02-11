require 'rails_helper'

describe CategoriesController do
  let(:user) { create(:user) }
  before     { sign_in(user) }

  describe "GET /index" do
    context "with success" do
      before { get :index }
      it { expect(response).to be_success }
      it { expect(response).to have_http_status(200) }
      it { expect(response).to render_template("index") }
    end

    context "with user with categories and without categories" do
      it "loads all of the categories into @categories" do
        category1, category2 = create(:category, user: user), create(:category, user: user)
        get :index

        expect(assigns(:categories)).to match_array([category1, category2])
      end

      it "another user cant see categories" do
        another_user = create(:user)
        sign_out(user)
        sign_in(another_user)
        expect(another_user.categories).to match_array([])
      end
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

  describe "GET /show" do
    before {
      @category = create(:category, user_id: user.id)
      get :show, id: @category.id
    }

    it { expect(response).to render_template :show   }
    it { expect(assigns(:category)).to eq(@category) }
  end
end

