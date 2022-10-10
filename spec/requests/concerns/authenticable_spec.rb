require 'rails_helper'

# mimics rails request behaviour by containing a header attribute
class MockController
  include Authenticable
  attr_accessor :request

  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

RSpec.describe 'Concerns::Authenticable', type: :request do
  before do
    @user = create(:user)
    @authentication = MockController.new
  end

  it "should get user from Authorization token" do
    @authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: @user.id)
    expect(@user.id).to eq(@authentication.current_user.id)
  end

  it "should not get user from empty Authorization token" do
    @authentication.request.headers['Authorization'] = nil
    expect(@authentication.current_user).to be_nil
  end
end
