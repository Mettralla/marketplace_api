require 'rails_helper'

RSpec.describe Product, type: :model do
  before do
    @user = create(:user)
    @user_two = create(
      :user,
      email: 'two@two.org',
      password_digest: BCrypt::Password.create('tw0_pa$$')
    )
    @one = create(
      :product,
      title: 'TV Plosmo Philopps',
      price: 9999.99,
      published: false,
      user: @user
    )
    @two = create(
      :product,
      title: 'Azos Zeenbok',
      price: 499.99,
      published: false,
      user: @user_two
    )
    @another_tv = create(
      :product,
      title: 'Cheap TV',
      price: 99.99,
      published: false,
      user: @user_two
    )
  end

  it 'should have a positive price' do
    @one.price = -1
    expect(@one).to be_invalid
  end

  describe "should filter products by name" do
    it "should filter products by name" do
      expect(Product.filter_by_title('tv').count).to eq(2)
    end

    it "should filter products by name and sort them" do
      expect(Product.filter_by_title('tv').sort).to eq([@one, @another_tv])
    end
  end

  describe "should filter products by price" do
    it "should filter products by price and sort them" do
      expect(Product.above_or_equal_to_price(200).sort).to eq([@one, @two])
    end

    it "should filter products by price lower and sort them" do
      expect(Product.below_or_equal_to_price(200).sort).to eq([@another_tv])
    end
  end

  describe "should filter products by creation date" do
    it "should filter products by price and sort them" do
      @two.touch
      expect(Product.recent.to_a).to eq([@one, @two, @another_tv])
    end

    it "should filter products by price lower and sort them" do
      expect(Product.below_or_equal_to_price(200).sort).to eq([@another_tv])
    end
  end
end
