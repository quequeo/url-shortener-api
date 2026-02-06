require 'rails_helper'

RSpec.describe 'Redirects', type: :request do
  let(:user) { create(:user) }
  let(:link) { create(:link, user: user) }

  describe 'GET /:short_code' do
    it 'redirects to original URL with 302 status' do
      get "/#{link.short_code}"

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(link.original_url)
    end

    it 'enqueues visit tracking job' do
      expect do
        get "/#{link.short_code}"
      end.to have_enqueued_job(TrackVisitJob)
    end

    it 'creates a visit record' do
      expect do
        perform_enqueued_jobs do
          get "/#{link.short_code}"
        end
      end.to change(Visit, :count).by(1)

      visit = Visit.last
      expect(visit.link).to eq(link)
      expect(visit.ip_address).to be_present
    end

    it 'increments click count atomically' do
      initial_count = link.click_count

      get "/#{link.short_code}"

      expect(link.reload.click_count).to eq(initial_count + 1)
    end

    it 'returns 404 for invalid short code' do
      get '/invalid_code'

      expect(response).to have_http_status(:not_found)
    end

    it 'does not require authentication' do
      get "/#{link.short_code}"

      expect(response).to have_http_status(:found)
    end
  end
end
