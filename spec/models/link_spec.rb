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

    it 'generates short_code before create' do
      link = create(:link, short_code: nil)
      expect(link.short_code).to be_present
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

  describe '#device_stats' do
    it 'groups visits by browser with percentages' do
      link = create(:link)
      create(:visit, link: link, user_agent: 'Mozilla/5.0 Chrome/120.0')
      create(:visit, link: link, user_agent: 'Mozilla/5.0 Chrome/121.0')
      create(:visit, link: link, user_agent: 'Mozilla/5.0 Firefox/119.0')

      stats = link.device_stats

      chrome = stats.find { |d| d[:browser] == 'Chrome' }
      firefox = stats.find { |d| d[:browser] == 'Firefox' }
      expect(chrome[:count]).to eq(2)
      expect(chrome[:percentage]).to eq(66.7)
      expect(firefox[:count]).to eq(1)
      expect(firefox[:percentage]).to eq(33.3)
    end

    it 'returns empty array with no visits' do
      link = create(:link)

      expect(link.device_stats).to eq([])
    end
  end
end
