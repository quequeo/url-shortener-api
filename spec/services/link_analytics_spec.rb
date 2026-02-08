require 'rails_helper'

RSpec.describe LinkAnalytics do
  let(:link) { create(:link) }

  describe '#summary' do
    it 'includes link fields and visitor stats' do
      create(:visit, link: link, ip_address: '1.1.1.1')
      create(:visit, link: link, ip_address: '1.1.1.1')
      create(:visit, link: link, ip_address: '2.2.2.2')

      result = described_class.new(link).summary

      expect(result[:id]).to eq(link.id)
      expect(result[:original_url]).to eq(link.original_url)
      expect(result[:short_code]).to eq(link.short_code)
      expect(result[:unique_visitors]).to eq(2)
      expect(result[:total_visitors]).to eq(3)
    end

    it 'groups devices by OS with percentages' do
      create(:visit, link: link, user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)')
      create(:visit, link: link, user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)')
      create(:visit, link: link, user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)')

      devices = described_class.new(link).summary[:devices]

      windows = devices.find { |d| d[:os] == 'Windows' }
      macos = devices.find { |d| d[:os] == 'macOS' }
      expect(windows[:count]).to eq(2)
      expect(windows[:percentage]).to eq(66.7)
      expect(macos[:count]).to eq(1)
      expect(macos[:percentage]).to eq(33.3)
    end

    it 'returns empty devices with no visits' do
      result = described_class.new(link).summary

      expect(result[:devices]).to eq([])
      expect(result[:unique_visitors]).to eq(0)
      expect(result[:total_visitors]).to eq(0)
    end
  end
end
