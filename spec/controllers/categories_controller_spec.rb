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
          post :create, category: attributes_for(:category, user_id: user.id), format: :json
        }.to change(Category, :count).by(1)
      end

      it "returns a successful json string with success message" do
        post :create, category: attributes_for(:category, user_id: user.id), format: :json
        expect(response).to be_success
        expect(response).to have_http_status(:created)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['success']).to eq("Category was successfully created.")
      end
    end

    context "with invalid attributes" do
      it "does not save new category" do
        expect {
          post :create, category: attributes_for(:invalid_category, user_id: user.id), format: :json
        }.to_not change(Category, :count)
      end

      it "returns errors in json" do
        post :create, category: attributes_for(:invalid_category, user_id: user.id), format: :json
        expect(response).to be_unprocessable
        #expect(response.status).to eq(422)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["errors"]["name"]).to eq(["can't be blank"])
      end
    end
  end

  describe "PUT /update" do
    context "with valid params" do
      before {
        put :update, id: category.id, category: category.attributes = {name: "Books"}, format: :json
      }

      it "should returns a successful json string with success message" do
        expect(response).to be_success
        #expect(response.status).to eq(200)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['success']).to eq("Category was successfully updated.")
      end
    end

    context "with invalid params" do
      before {
        put :update, id: category.id, category: attributes_for(:invalid_category, user_id: user.id), format: :json
      }

      it "errors in json" do
        expect(response).to be_unprocessable
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["errors"]["name"]).to eq(["can't be blank"])
      end
    end
  end

  describe "DELETE /destroy" do
    it { delete :destroy, id: category.id }
  end
end

