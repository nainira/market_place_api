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
end
