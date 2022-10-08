require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  before { @first_user = create(:user) }

  describe "GET /show" do
    it "should show a user" do
      get '/api/v1/users/1'
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(@first_user.email).to eq(json_response['email'])
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
      patch '/api/v1/users/1', params: {
        user: {
          email: 'two@two.org',
          password: 'trustno1'
        }
      }
      expect(response).to have_http_status(:success)
    end

    it "should not update user when invalid params are sent" do
      patch '/api/v1/users/1', params: {
        user: {
          email: 'test',
          password: 'trustno1'
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end