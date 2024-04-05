# frozen_string_literal: true

module Api
  module V1
    module Users
      class AccessTokensController < Api::V1Controller
        skip_before_action :authenticate

        before_action :find_user, only: %i[create]
        before_action :authenticate_user, only: %i[create]

        SERIALIZER_FIELDS = %w[username access_token].freeze

        def create
          render json: {
            user: UserSerializer.new(
              @user, params: serializer_fields(UserSerializer, SERIALIZER_FIELDS)
            ).serializable_hash
          }, status: :created
        end

        private

        def find_user
          @user = User.find_by!(username: user_params[:username])
        end

        def authenticate_user
          return if @user.authenticate(user_params[:password])

          render json: { errors: [t('controllers.users.sessions.invalid')] }, status: :unprocessable_entity
        end

        def user_params
          params.require(:user).permit(:username, :password)
        end
      end
    end
  end
end
