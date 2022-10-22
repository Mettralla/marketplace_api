require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  before do
    @user = create(:user)
    @user_three = create(
      :user,
      email: 'third@third.org',
      password_digest: BCrypt::Password.create('th1rd_pa$$')
    )
    @product = create(:product, user: @user)
  end

  describe "GET show" do
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

  describe 'POST create' do
    it "should create product" do
      expect{
        post '/api/v1/products',
        params: {
          product: {
            title: @product.title,
            price: @product.price,
            published: @product.published
          }
        },
        headers: {
          Authorization: JsonWebToken.encode(user_id: @user.id)
        }
      }.to change { Product.count }.from(1).to(2)

      expect(response).to have_http_status(:created)
    end

    it 'should forbid create product' do
      expect{
        post '/api/v1/products',
        params: {
          product: {
            title: @product.title,
            price: @product.price,
            published: @product.published
          }
        }
      }.not_to change { Product.count }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /update" do
    it "should update product" do
      patch '/api/v1/products/1',
        params: {
          product: { title: @product.title }
        },
        headers: {
          Authorization: JsonWebToken.encode(user_id: @user.id)
        }

      expect(response).to have_http_status(:success)
    end

    it "should forbid update product" do
      patch '/api/v1/products/1',
        params: { 
          product: { title: @product.title }
        },
        headers: {
          Authorization: JsonWebToken.encode(user_id: @user_three.id)
        }

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE" do
    it "should destroy product" do
      expect {
        delete '/api/v1/products/1', 
        headers: { 
          Authorization: JsonWebToken.encode(user_id: @user.id)
        }
      }.to change { Product.count }.from(1).to(0)
      expect(response).to have_http_status(:no_content)
    end

    it "should forbid delete product" do
      expect {
        delete '/api/v1/products/1',
        headers: { 
          Authorization: JsonWebToken.encode(user_id: @user_three.id)
        }
      }.not_to change { Product.count }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
