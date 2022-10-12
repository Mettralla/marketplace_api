require 'rails_helper'

RSpec.describe Product, type: :model do
  before do
    @user = create(:user)
    @product = create(:product, user: @user)
  end

  it 'should have a positive price' do
    @product.price = -1
    expect(@product).to be_invalid
  end
end
