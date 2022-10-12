require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  before do
    @user = create(:user)
    @product = create(:product, user: @user)
  end

  describe "GET /show" do
    it "should show product" do
      get '/api/v1/products/1'
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(@product.title).to eq(json_response['title'])
    end

    it 'should show products' do
      get '/api/v1/products/1'
      expect(response).to have_http_status(:success)
    end
  end
end
