require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /show" do
    before { @first_user = create(:user) }
    it "should show a user" do
      get '/api/v1/users/1'
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(@first_user.email).to eq(json_response['email'])
    end
  end
end
