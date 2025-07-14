# app/controllers/api/v1/application_controller.rb
module Api
  module V1
    class ApplicationController < ActionController::API
      before_action :authenticate_user

      private

      def authenticate_user
        token = request.headers['token']
        return render json: { error: 'Unauthorized' }, status: :unauthorized unless token

        decoded = JwtService.decode(token)
        return render json: { error: 'Invalid token' }, status: :unauthorized unless decoded

        @current_user = User.find_by(id: decoded[:user_id])
        render json: { error: 'User not found' }, status: :unauthorized unless @current_user
      end

      def current_user
        @current_user
      end
    end
  end
end
