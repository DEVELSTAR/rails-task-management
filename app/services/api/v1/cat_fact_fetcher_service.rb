# app/services/cat_fact_fetcher_service.rb
require "net/http"
require "json"
module Api
  module V1
    class CatFactFetcherService
        CATFACT_API_URL = "https://catfact.ninja/fact".freeze

        def self.call
            url = URI.parse(CATFACT_API_URL)

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.open_timeout = 3
            http.read_timeout = 3

            response = http.get(url.request_uri)
            data = JSON.parse(response.body)
            fact_text = data["fact"]

            # Save to DB and return the record
            CatFact.create!(fact: fact_text, source: "catfact.ninja")
        rescue Net::OpenTimeout, Net::ReadTimeout
            raise StandardError, "Cat fact API timeout."
        rescue => e
            Rails.logger.error("CatFact fetch failed: #{e.message}")
            raise StandardError, "Cat fact fetch failed."
        end
    end
  end
end
