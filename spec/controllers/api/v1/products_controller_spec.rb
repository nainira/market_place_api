require 'rails_helper'

RSpec.describe Api::V1::ProductsController, :type => :controller do
  # before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1, #{Mime::JSON}" }
  # before(:each) { request.headers['Content-Type'] = Mime::JSON.to_s }

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns the information about a reporter on a hash" do
      product_response = json_response
      expect(product_response[:title]).to eql @product.title
    end

    it { is_expected.to respond_with 200 }
  end # GET #show

  describe "Get #index" do
    before(:each) do
      4.times { FactoryGirl.create :product}
      get :index
    end

    it "returns 4 records from the database" do
      products_response = json_response
      expect(products_response[:products]).to have(4).items
      ### Examples ###
      # expect(collection).to have(n).items
      # expect(collection).to have_exactly(n).items
      # expect(collection).to have_at_most(n).items
      # expect(collection).to have_at_least(n).items
    end

    it { is_expected.to respond_with 200 }
  end # Get #index

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @product_attributes }
      end

      it "renders the json representation for the product record just created" do
        product_response = json_response
        expect(product_response[:title]).to eql @product_attributes[:title]
      end

      it { is_expected.to respond_with 201 }

    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: "Smart TV", price: "Twelve dollars" }
        api_authorization_header user.auth_token

        post :create, { user_id: user.id, product: @invalid_product_attributes }
      end

      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { is_expected.to respond_with 422 }
    end
  end # POST #create

  describe "PUT/PATCH #update" do
    # let(:user) { FactoryGirl.create :user }
    # let(:product) { FactoryGirl.create :product, user: @user }
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, product: { title: "An expensive TV"} }
      end

      it "renders the json representation for the updated user" do
        product_response = json_response
        expect(product_response[:title]).to eql "An expensive TV"
      end

      it { is_expected.to respond_with 200}
    end # when is successfully updated

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id, product: { price: "two hundred"} }
      end

      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { is_expected.to respond_with 422 }
    end
  end # PUT/PATCH #update

end
