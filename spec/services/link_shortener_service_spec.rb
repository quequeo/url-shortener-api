require 'rails_helper'

RSpec.describe LinkShortenerService do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user) }

  describe '#shorten' do
    context 'with valid URL' do
      let(:url) { 'https://google.com' }

      it 'creates a link with Redis counter' do
        link = service.shorten(url)

        expect(link).to be_persisted
        expect(link.short_code).to match(/\A[0-9a-zA-Z]+\z/)
        expect(link.original_url).to eq(url)
      end

      it 'generates sequential codes' do
        link1 = service.shorten(url)
        link2 = service.shorten(url)

        expect(link1.short_code).not_to eq(link2.short_code)
      end
    end

    context 'when Redis fails' do
      let(:url) { 'https://google.com' }

      it 'uses timestamp fallback' do
        allow(REDIS_CLIENT).to receive(:incr).and_raise(Redis::CannotConnectError)

        link = service.shorten(url)

        expect(link).to be_persisted
        expect(link.short_code).to match(/\A[0-9a-zA-Z]+\z/)
        expect(link.short_code.length).to eq(8)
      end
    end

    context 'with invalid URL' do
      it 'raises RecordInvalid for invalid URL' do
        expect { service.shorten('not-a-url') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
