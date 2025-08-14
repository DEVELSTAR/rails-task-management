# spec/requests/api/v1/quran_verses_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::QuranVersesController, type: :request do
  describe 'GET /api/v1/quran_verses' do
    before { create_list(:quran_verse, 15) }

    it 'returns paginated verses' do
      get '/api/v1/quran_verses', params: { page: 1, per_page: 10 }
      expect(response).to have_http_status(:ok)
      expect(json['verses'].size).to eq(10)
      expect(json['meta']['total_count']).to eq(15)
    end

    it 'returns 10 by default if per_page is not set' do
      get '/api/v1/quran_verses'
      expect(json['verses'].size).to eq(10)
    end
  end

  describe 'DELETE /api/v1/quran_verses/:id' do
    let!(:verse) { create(:quran_verse) }

    it 'deletes a verse' do
      expect {
        delete "/api/v1/quran_verses/#{verse.id}"
      }.to change(QuranVerse, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'returns not found for non-existent verse' do
      delete '/api/v1/quran_verses/999999'
      expect(response).to have_http_status(:not_found)
      expect(json['error']).to eq('Verse not found')
    end
  end

  describe 'POST /api/v1/quran_verses/fetch_verse' do
    let(:ayah_number) { 1 }
    let(:language) { 'en.asad' }

    it 'fetches a new verse successfully' do
      mock_verse = {
        surah_name: 'Al-Fatiha',
        verse_number: 1,
        language: language,
        text: 'In the name of Allah...'
      }

      allow(Api::V1::QuranVerseFetcherService).to receive(:call).with(ayah_number.to_s, language).and_return(mock_verse)

      post '/api/v1/quran_verses/fetch_verse', params: {
        ayah_number: ayah_number,
        language: language
      }

      expect(response).to have_http_status(:created)
      expect(json['surah_name']).to eq('Al-Fatiha')
    end

    it 'uses default language when not provided' do
      allow(Api::V1::QuranVerseFetcherService).to receive(:call).and_return({ verse_number: 1 })

      post '/api/v1/quran_verses/fetch_verse', params: { ayah_number: 1 }

      expect(response).to have_http_status(:created)
    end

    it 'returns error when service fails' do
      allow(Api::V1::QuranVerseFetcherService).to receive(:call).and_raise(StandardError.new("API Failure"))

      post '/api/v1/quran_verses/fetch_verse', params: { ayah_number: 1, language: 'en.asad' }

      expect(response).to have_http_status(:service_unavailable)
      expect(json['error']).to eq('API Failure')
    end
  end
end
