require 'rails_helper'

RSpec.describe 'Api::V1::Profile', type: :request do
  describe 'GET /api/v1/profile' do
    let(:user) { create(:user) }

    it 'returns user profile with api_key' do
      sign_in user
      get '/api/v1/profile'

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json['email']).to eq(user.email)
      expect(json['name']).to eq(user.name)
      expect(json['api_key']).to eq(user.api_key)
    end

    it 'returns unauthorized without auth' do
      get '/api/v1/profile'

      expect(response).to have_http_status(:unauthorized)
    end

    it 'authenticates with X-API-Key header' do
      get '/api/v1/profile', headers: { 'X-API-Key' => user.api_key }

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json['email']).to eq(user.email)
    end

    it 'rejects invalid X-API-Key' do
      get '/api/v1/profile', headers: { 'X-API-Key' => 'invalid' }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
