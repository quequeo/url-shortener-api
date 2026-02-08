require 'rails_helper'

RSpec.describe 'Api::V1::Top', type: :request do
  describe 'GET /api/v1/top' do
    it 'returns links ordered by click_count desc without authentication' do
      user = create(:user)
      create(:link, user: user, click_count: 5)
      high = create(:link, user: user, click_count: 50)

      get api_v1_top_index_path

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json.first['short_code']).to eq(high.short_code)
    end

    it 'limits results to 100' do
      user = create(:user)
      create_list(:link, 101, user: user, click_count: 1)

      get api_v1_top_index_path

      expect(response.parsed_body.size).to eq(100)
    end
  end
end
