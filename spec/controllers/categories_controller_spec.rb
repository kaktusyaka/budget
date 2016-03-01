require 'rails_helper'

describe CategoriesController do
  let(:user)     { create(:user) }
  before         { sign_in(user) }
  let(:category) { create(:category, name: "Kids", user_id: user.id) }

  describe "GET /index" do
    context "with success" do
      before { get :index }

      it { expect(response).to be_success }
      it { expect(response).to have_http_status(200) }
      it { expect(response).to render_template("index") }
    end

    context "with user with categories and without categories" do
      it "loads all of the categories into @categories" do
        category2 = create(:category, user: user)
        get :index

        expect(assigns(:categories)).to match_array([category, category2])
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

        expect(response).to redirect_to categories_url
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

  describe "PUT /update" do
    context "with valid params" do
      before {
        put :update, id: category.id, category: category.attributes = {name: "Books"}
      }

      it { expect(response).to redirect_to categories_url  }
    end

    context "with invalid params" do
      before {
        put :update, id: category.id, category: attributes_for(:invalid_category, user_id: user.id)
      }

      it { expect(response).to render_template :edit  }
    end
  end

  describe "DELETE /destroy" do
    it { delete :destroy, id: category.id }
  end
end

