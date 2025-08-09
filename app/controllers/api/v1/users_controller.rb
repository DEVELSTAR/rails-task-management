module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user, except: [:register, :login, :index, :show]
      before_action :set_user, only: [:show, :update]

      def index
        users = User.includes(:profile, :addresses)
                    .page(params[:page])
                    .per(params[:per_page] || 10)

        render json: {
          data: users.map { |user| UserSerializer.new(user).as_json },
          meta: paginate(users)
        }
      end

      def show
        render json: UserSerializer.new(@user).as_json
      end

      def register
        user = User.new(user_params)
        if user.save
          token = JwtService.encode(user_id: user.id)
          render json: { user: UserSerializer.new(user).as_json, token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: UserSerializer.new(@user).as_json
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JwtService.encode(user_id: user.id)
          render json: {
            user: UserSerializer.new(user, include: [:profile, :addresses]).serializable_hash,
            token: token
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :not_found
      end

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation,
          profile_attributes: [:id, :name, :bio, :avatar, :_destroy],
          addresses_attributes: [:id, :line1, :line2, :city, :state, :zip, :country, :_destroy]
        )
      end
    end
  end
end
