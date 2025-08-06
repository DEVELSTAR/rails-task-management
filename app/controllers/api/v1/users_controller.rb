# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user
      before_action :set_user, only: [:show]
      
      def index
        users = User.page(params[:page]).per(params[:per_page] || 10)
        render json: UserSerializer.new(users, meta: paginate(users)).serializable_hash
      end

      def show
        render json: UserSerializer.new(@user).serializable_hash
      end

      def register
        user = User.new(user_params)
        if user.save
          token = JwtService.encode(user_id: user.id)
          render json: { user: { id: user.id, email: user.email }, token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JwtService.encode(user_id: user.id)
          render json: { user: { id: user.id, email: user.email }, token: token }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      end

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
