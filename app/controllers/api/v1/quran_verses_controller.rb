# app/controllers/api/v1/quran_verses_controller.rb
module Api
  module V1
    class QuranVersesController < ApplicationController
      skip_before_action :authenticate_user

      def index
        verses = QuranVerse.page(params[:page]).per(params[:per_page] || 10)
        render json: { verses: verses, meta: paginate(verses) }
      end

      def destroy
        verse = QuranVerse.find(params[:id])
        verse.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Verse not found" }, status: :not_found
      end

      def fetch_verse
        language = params[:language] || QuranVerseFetcherService::DEFAULT_LANG
        verse = QuranVerseFetcherService.call(params[:ayah_number], language)
        render json: verse, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :service_unavailable
      end
    end
  end
end
