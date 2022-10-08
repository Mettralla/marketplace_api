require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    it 'user with valid data should be valid:' do
      expect(build(:user)).to be_valid
    end

    it 'user with invalid email shoud be invalid' do
      expect(build(:user, email: 'test', password_digest: 'test')).to be_invalid
    end

    it 'user with taken email should be invalid' do
      other_user = create(:user)
      new_user = build(:user, email: other_user.email, password_digest: 'testOne')
      expect(new_user).to be_invalid
    end
  end
end
