require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  before do
    @user = create(:user)
    @product = create(:product, user: @user)
  end

  describe "GET /show" do
    it "should show a user" do
      get '/api/v1/users/1'
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(@user.email).to eq(json_response['data']['attributes']['email'])
    end
  end

  describe "POST /users" do
    it "should create user" do
      expect {
        post '/api/v1/users', params: {
          user: {
            email: 'test@test',
            password: '123456'
          }
        }
      }.to change { User.count }.from(1).to(2)

      expect(response).to have_http_status(:created)
    end

    it 'should not create user with taken email' do
      expect {
        post '/api/v1/users', params: {
          user: {
            email: 'one@one.org',
            password: 'trustno1'
          }
        }
      }.not_to change { User.count }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "should update user" do
      patch '/api/v1/users/1',
        params: { user: { email: 'two@two.org' } },
        headers: { Authorization: JsonWebToken.encode(user_id: @user.id) }

      expect(response).to have_http_status(:success)
    end

    it "should forbid update user" do
      patch '/api/v1/users/1', params: { user: { email: 'two@two.org' } }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /users/:id" do
    it 'should destroy user' do
      expect {
        delete '/api/v1/users/1', headers: { Authorization: JsonWebToken.encode(user_id: @user.id) }
      }.to change { User.count }.from(1).to(0)
      expect(response).to have_http_status(:no_content)
    end

    it 'should forbid destroy user' do
      expect {
        delete '/api/v1/users/1'
      }.not_to change { User.count }
      expect(response).to have_http_status(:forbidden)
    end

    it 'destroy user should destroy linked product' do
      expect {
        delete '/api/v1/users/1', headers: { Authorization: JsonWebToken.encode(user_id: @user.id) }
      }.to change { Product.count }.from(1).to(0)
      expect(response).to have_http_status(:no_content)
    end
  end
end
