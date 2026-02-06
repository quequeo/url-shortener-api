require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      expect(build(:link)).to be_valid
    end

    it 'requires original_url' do
      link = build(:link, original_url: nil)
      expect(link).not_to be_valid
      expect(link.errors[:original_url]).to include("can't be blank")
    end

    it 'requires short_code' do
      link = build(:link, short_code: nil)
      expect(link).not_to be_valid
      expect(link.errors[:short_code]).to include("can't be blank")
    end

    it 'requires unique short_code' do
      create(:link, short_code: '2abc123')
      link = build(:link, short_code: '2abc123')
      expect(link).not_to be_valid
      expect(link.errors[:short_code]).to include('has already been taken')
    end

    it 'rejects invalid URL' do
      link = build(:link, original_url: 'not-a-url')
      expect(link).not_to be_valid
      expect(link.errors[:original_url]).to be_present
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      link = build(:link)
      expect(link.user).to be_present
    end
  end
end
