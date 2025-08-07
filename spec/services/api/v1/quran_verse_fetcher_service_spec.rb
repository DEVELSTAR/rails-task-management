require 'rails_helper'
require 'net/http'

RSpec.describe Api::V1::QuranVerseFetcherService, type: :service do
  let(:ayah_number) { 1 }
  let(:language) { "en.asad" }
  let(:url) { URI.parse("https://api.alquran.cloud/v1/ayah/#{ayah_number}/#{language}") }

  describe ".call" do
    context "when API returns a successful response" do
      let(:response_body) {
        {
          status: "OK",
          data: {
            surah: {
              englishName: "Al-Fatihah",
              number: 1
            },
            numberInSurah: 1,
            text: "In the name of Allah, the Entirely Merciful, the Especially Merciful."
          }
        }.to_json
      }

      before do
        response_double = instance_double(Net::HTTPOK, body: response_body)
        http_double = instance_double(Net::HTTP)

        allow(Net::HTTP).to receive(:new).with(url.host, url.port).and_return(http_double)
        allow(http_double).to receive(:use_ssl=).with(true)
        allow(http_double).to receive(:open_timeout=).with(3)
        allow(http_double).to receive(:read_timeout=).with(3)
        allow(http_double).to receive(:get).with(url.request_uri).and_return(response_double)
      end

      it "creates and returns a QuranVerse record" do
        expect {
          result = described_class.call(ayah_number, language)
          expect(result).to be_a(QuranVerse)
          expect(result.surah_name).to eq("Al-Fatihah")
          expect(result.verse_number).to eq("1:1")
          expect(result.text).to eq("In the name of Allah, the Entirely Merciful, the Especially Merciful.")
          expect(result.language).to eq(language)
        }.to change(QuranVerse, :count).by(1)
      end
    end

    context "when the API times out" do
      before do
        allow(Net::HTTP).to receive(:new).and_raise(Net::OpenTimeout)
      end

      it "raises a timeout error" do
        expect {
          described_class.call(ayah_number, language)
        }.to raise_error(StandardError, "Quran API timeout.")
      end
    end

    context "when the API returns a failure status" do
      let(:invalid_body) { { status: "FAILED" }.to_json }

      before do
        response_double = instance_double(Net::HTTPOK, body: invalid_body)
        http_double = instance_double(Net::HTTP)

        allow(Net::HTTP).to receive(:new).with(url.host, url.port).and_return(http_double)
        allow(http_double).to receive(:use_ssl=).with(true)
        allow(http_double).to receive(:open_timeout=).with(3)
        allow(http_double).to receive(:read_timeout=).with(3)
        allow(http_double).to receive(:get).with(url.request_uri).and_return(response_double)
      end

      it "raises a fetch failure error" do
        expect {
          described_class.call(ayah_number, language)
        }.to raise_error(StandardError, "Quran verse fetch failed.")
      end
    end

    context "when a generic error occurs" do
      before do
        allow(Net::HTTP).to receive(:new).and_raise(StandardError.new("Something went wrong"))
      end

      it "logs and raises a generic fetch failure" do
        expect(Rails.logger).to receive(:error).with(/Quran verse fetch failed: Something went wrong/)
        expect {
          described_class.call(ayah_number, language)
        }.to raise_error(StandardError, "Quran verse fetch failed.")
      end
    end
  end
end
