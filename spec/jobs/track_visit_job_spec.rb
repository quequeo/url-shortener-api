require 'rails_helper'

RSpec.describe TrackVisitJob, type: :job do
  let(:user) { create(:user) }
  let(:link) { create(:link, user: user) }

  describe '#perform' do
    it 'creates a visit record' do
      expect do
        described_class.perform_now(link.id, '127.0.0.1', 'Mozilla/5.0')
      end.to change(Visit, :count).by(1)

      visit = Visit.last
      expect(visit.link_id).to eq(link.id)
      expect(visit.ip_address).to eq('127.0.0.1')
      expect(visit.user_agent).to eq('Mozilla/5.0')
    end
  end
end
