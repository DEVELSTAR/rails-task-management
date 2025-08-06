# app/services/quran_verse_fetcher_service.rb
require 'net/http'
require 'json'
module Api
  module V1
    class QuranVerseFetcherService
        QURAN_API_URL = "https://api.alquran.cloud/v1/ayah/".freeze
        DEFAULT_LANG = "ur.junagarhi"

        # language param: e.g., "en.asad", "ur.junagarhi"
        def self.call(ayah_number = nil, language = DEFAULT_LANG)
            ayah_number ||= rand(1..6236)
            url = URI.parse("#{QURAN_API_URL}#{ayah_number}/#{language}")

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.open_timeout = 3
            http.read_timeout = 3

            response = http.get(url.request_uri)
            data = JSON.parse(response.body)

            raise StandardError, "Failed to fetch Quran verse" unless data["status"] == "OK"

            verse_data = data["data"]
            surah_name = verse_data["surah"]["englishName"]
            verse_number = "#{verse_data["surah"]["number"]}:#{verse_data["numberInSurah"]}"
            text = verse_data["text"]

            QuranVerse.create!(
            surah_name: surah_name,
            verse_number: verse_number,
            text: text,
            source: "api.alquran.cloud",
            language: language
            )
        rescue Net::OpenTimeout, Net::ReadTimeout
            raise StandardError, "Quran API timeout."
        rescue => e
            Rails.logger.error("Quran verse fetch failed: #{e.message}")
            raise StandardError, "Quran verse fetch failed."
        end
    end
  end
end
