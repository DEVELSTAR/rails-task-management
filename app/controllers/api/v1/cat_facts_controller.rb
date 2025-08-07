# app/controllers/api/v1/cat_facts_controller.rb
module Api
  module V1
    class CatFactsController < ApplicationController
      skip_before_action :authenticate_user
      require "net/http"
      require "json"

      def index
        facts = CatFact.page(params[:page]).per(params[:per_page] || 10)
        render json: { facts: facts, meta: paginate(facts) }
      end

      def destroy
        fact = CatFact.find(params[:id])
        fact.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Cat fact not found" }, status: :not_found
      end

      def random_facts
        fact = CatFactFetcherService.call
        render json: fact, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :service_unavailable
      end

      private

      def cat_fact_params
        params.require(:cat_fact).permit(:fact)
      end
    end
  end
end
