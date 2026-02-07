require 'rails_helper'

RSpec.describe 'Api::V1::Links', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET /api/v1/links' do
    it 'returns user links ordered by created_at desc' do
      sign_in user
      create(:link, user: user)
      link2 = create(:link, user: user)

      get api_v1_links_path

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json.size).to eq(2)
      expect(json.first['id']).to eq(link2.id)
    end

    it 'requires authentication' do
      get api_v1_links_path

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/links' do
    it 'creates a link with valid URL' do
      sign_in user

      post api_v1_links_path, params: { url: 'https://google.com' }

      expect(response).to have_http_status(:created)
      json = response.parsed_body
      expect(json['original_url']).to eq('https://google.com')
      expect(json['short_code']).to match(/\A[0-9a-zA-Z]+\z/)
      expect(json['short_code'].length).to be >= 3
    end

    it 'returns error for invalid URL' do
      sign_in user

      post api_v1_links_path, params: { url: 'not-a-url' }

      expect(response).to have_http_status(:unprocessable_content)
      json = response.parsed_body
      expect(json['error']).to be_present
    end

    it 'returns error for missing url parameter' do
      sign_in user

      post api_v1_links_path, params: {}

      expect(response).to have_http_status(:bad_request)
      json = response.parsed_body
      expect(json['error']).to include('url')
    end
  end

  describe 'GET /api/v1/links/:id' do
    it 'returns own link' do
      sign_in user
      link = create(:link, user: user)

      get api_v1_link_path(link)

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json['id']).to eq(link.id)
    end

    it 'returns 404 for other user link' do
      sign_in user
      link = create(:link, user: other_user)

      get api_v1_link_path(link)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH /api/v1/links/:id' do
    it 'updates own link with valid URL' do
      sign_in user
      link = create(:link, user: user)

      patch api_v1_link_path(link), params: { original_url: 'https://github.com' }

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json['original_url']).to eq('https://github.com')
      expect(json['short_code']).to eq(link.short_code)
    end

    it 'returns error for invalid URL' do
      sign_in user
      link = create(:link, user: user)

      patch api_v1_link_path(link), params: { original_url: 'not-a-url' }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'returns 404 for other user link' do
      sign_in user
      link = create(:link, user: other_user)

      patch api_v1_link_path(link), params: { original_url: 'https://github.com' }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/links/:id' do
    it 'deletes own link' do
      sign_in user
      link = create(:link, user: user)

      delete api_v1_link_path(link)

      expect(response).to have_http_status(:no_content)
      expect(Link.exists?(link.id)).to be false
    end
  end
end
