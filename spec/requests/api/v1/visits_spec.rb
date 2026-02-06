require 'rails_helper'

RSpec.describe 'Api::V1::Visits', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:link) { create(:link, user: user) }

  describe 'GET /api/v1/links/:link_id/visits' do
    it 'returns visits for own link' do
      sign_in user
      create(:visit, link: link)
      visit2 = create(:visit, link: link)

      get api_v1_link_visits_path(link)

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json.size).to eq(2)
      expect(json.first['id']).to eq(visit2.id)
    end

    it 'returns 404 for other user link' do
      sign_in other_user

      get api_v1_link_visits_path(link)

      expect(response).to have_http_status(:not_found)
    end

    it 'requires authentication' do
      get api_v1_link_visits_path(link)

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
