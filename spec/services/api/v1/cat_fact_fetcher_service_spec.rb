require 'rails_helper'
require 'net/http'

RSpec.describe Api::V1::CatFactFetcherService, type: :service do
  let(:url) { URI.parse('https://catfact.ninja/fact') }

  describe '.call' do
    context 'when API returns a successful response' do
      let(:api_response) { { fact: "Cats sleep 70% of their lives." }.to_json }

      before do
        response_double = instance_double(Net::HTTPOK, body: api_response)
        http_double = instance_double(Net::HTTP)

        allow(Net::HTTP).to receive(:new).with(url.host, url.port).and_return(http_double)
        allow(http_double).to receive(:use_ssl=).with(true)
        allow(http_double).to receive(:open_timeout=).with(3)
        allow(http_double).to receive(:read_timeout=).with(3)
        allow(http_double).to receive(:get).with(url.request_uri).and_return(response_double)
      end

      it 'creates and returns a new CatFact record' do
        expect {
          result = described_class.call
          expect(result).to be_a(CatFact)
          expect(result.fact).to eq("Cats sleep 70% of their lives.")
          expect(result.source).to eq("catfact.ninja")
        }.to change(CatFact, :count).by(1)
      end
    end

    context 'when API times out' do
      before do
        allow(Net::HTTP).to receive(:new).and_raise(Net::ReadTimeout)
      end

      it 'raises a timeout error' do
        expect {
          described_class.call
        }.to raise_error(StandardError, "Cat fact API timeout.")
      end
    end

    context 'when API returns unexpected error' do
      before do
        allow(Net::HTTP).to receive(:new).and_raise(StandardError.new("unexpected error"))
      end

      it 'logs and raises a generic fetch failure' do
        expect(Rails.logger).to receive(:error).with(/CatFact fetch failed: unexpected error/)
        expect {
          described_class.call
        }.to raise_error(StandardError, "Cat fact fetch failed.")
      end
    end
  end
end
