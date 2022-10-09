require 'rails_helper'

RSpec.describe "Api::V1::Tokens", type: :request do
  before { @user = create(:user) }
  describe 'JWT Token'
    it "should get JTW token" do
      post '/api/v1/tokens', params: {
        user: {
          email: @user.email,
          password: 'g00d_pa$$'
        }
      }
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['token']).to_not be_nil
    end

    it 'should not get JWT token' do
      post '/api/v1/tokens', params: {
          user: {
            email: @user.email,
            password: 'bad_pa$$'
          }
        }
        expect(response).to have_http_status(:unauthorized)
    end
end
