require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'requires a name' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'requires a unique email' do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to include('has already been taken')
    end
  end

  describe 'api_key' do
    it 'generates api_key on create' do
      user = create(:user)
      expect(user.api_key).to be_present
      expect(user.api_key.length).to eq(40)
    end
  end
end
