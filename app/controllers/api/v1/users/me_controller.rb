# frozen_string_literal: true

module Api
  module V1
    module Users
      class MeController < Api::V1Controller
        SERIALIZER_FIELDS = %w[username].freeze
        FORBIDDEN_FIELDS = %w[access_token].freeze

        def index
          render json: {
            user: UserSerializer.new(
              Current.user, params: serializer_fields(UserSerializer, SERIALIZER_FIELDS, FORBIDDEN_FIELDS)
            ).serializable_hash
          }, status: :ok
        end
      end
    end
  end
end
