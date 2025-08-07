# spec/requests/api/v1/cat_facts_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::CatFactsController, type: :request do
  describe 'GET /api/v1/cat_facts' do
    before do
      create_list(:cat_fact, 15)
    end

    it 'returns paginated cat facts' do
      get '/api/v1/cat_facts', params: { page: 1, per_page: 10 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['facts'].size).to eq(10)
      expect(json['meta']['total_count']).to eq(15)
    end

    it 'returns all cat facts when per_page not specified' do
      get '/api/v1/cat_facts'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['facts'].size).to eq(10)
    end
  end

  describe 'DELETE /api/v1/cat_facts/:id' do
    let!(:cat_fact) { create(:cat_fact) }

    it 'deletes the cat fact' do
      expect {
        delete "/api/v1/cat_facts/#{cat_fact.id}"
      }.to change(CatFact, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 when fact not found' do
      delete "/api/v1/cat_facts/9999"
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Cat fact not found')
    end
  end

  describe 'POST /api/v1/cat_facts/random_facts' do
    it 'returns a random cat fact successfully' do
      allow(Api::V1::CatFactFetcherService).to receive(:call).and_return({ fact: 'Cats purr at 26 purrs/sec' })

      post '/api/v1/cat_facts/random_facts'
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['fact']).to eq('Cats purr at 26 purrs/sec')
    end

    it 'returns error if external service fails' do
      allow(Api::V1::CatFactFetcherService).to receive(:call).and_raise(StandardError.new('API Down'))

      post '/api/v1/cat_facts/random_facts'
      expect(response).to have_http_status(:service_unavailable)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('API Down')
    end
  end
end
