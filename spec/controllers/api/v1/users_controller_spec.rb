require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :controller do
  # we concatenate the json format
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1, #{Mime::JSON}" }
  before(:each) { request.headers['Content-Type'] = Mime::JSON.to_s }
  describe "Get #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id
    end
    # JSOsN.parse(response.body, symbolize_names: true)
    #  ==
    #  json.response
    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { is_expected.to respond_with 200 }
  end #show

  describe "Post #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { is_expected.to respond_with 201 }
    end # when is successfully created

    context "when is not created" do
      before(:each) do
        # notice I'm not including the email
        @invalid_user_attributes = { password: '12345678', password_confirmation: '12345678'}
        # post :create, { user: @invalid_user_attributes }, format: :json
        post :create, { user: @invalid_user_attributes }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end # when is not created
  end # post

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] = @user.auth_token
    end
    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        # patch :update, { id: @user.id,
        #                  user: { email: "newmail@example.com" } }, format: :json
        patch :update, { id: @user.id,
                         user: { email: "newmail@example.com" } }
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "newmail@example.com"
      end

      it { is_expected.to respond_with 200 }
    end # when is successfully updated

    context "when is not created" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id,
                         user: { email: "bademail.com" } }, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { is_expected.to respond_with 422 }

    end # when is not created
  end # PUT/PATCH #update

  describe "Delete #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header(@user.auth_token)
      delete :destroy, { id: @user.id }, format: :json
    end

    it { is_expected.to respond_with 204 }

  end

end # end
