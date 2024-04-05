# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1Controller
      include Deps[create_form: 'forms.users.create']

      skip_before_action :authenticate

      SERIALIZER_FIELDS = %w[username access_token].freeze

      def create
        case create_form.call(params: user_params.to_h.symbolize_keys)
        in { errors: errors } then render json: { errors: errors }, status: :unprocessable_entity
        in { result: result }
          render json: {
            user: UserSerializer.new(
              result, params: serializer_fields(UserSerializer, SERIALIZER_FIELDS)
            ).serializable_hash
          }, status: :created
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :password, :password_confirmation)
      end
    end
  end
end
