# frozen_string_literal: true

module Api
  module V1
    class WorldsController < Api::V1Controller
      skip_before_action :authenticate
      before_action :find_worlds, only: %i[index]

      SERIALIZER_FIELDS = %w[id ticks map_size name].freeze

      def index
        render json: {
          worlds: WorldSerializer.new(
            @worlds, params: serializer_fields(WorldSerializer, SERIALIZER_FIELDS)
          ).serializable_hash
        }, status: :ok
      end

      private

      def find_worlds
        @worlds = World.order(id: :desc)
      end
    end
  end
end
