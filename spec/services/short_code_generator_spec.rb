require 'rails_helper'

RSpec.describe ShortCodeGenerator do
  describe '.call' do
    it 'generates a 6-char Base62 code' do
      code = described_class.call

      expect(code).to match(/\A[0-9a-zA-Z]{6}\z/)
    end

    it 'generates unique codes' do
      codes = Array.new(5) { described_class.call }

      expect(codes.uniq.size).to eq(5)
    end

    context 'when Redis fails' do
      it 'uses random fallback' do
        allow(REDIS_CLIENT).to receive(:incr).and_raise(Redis::CannotConnectError)

        code = described_class.call

        expect(code).to match(/\A[0-9a-zA-Z]{6}\z/)
      end
    end
  end
end
