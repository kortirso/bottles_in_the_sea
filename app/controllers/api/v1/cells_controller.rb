# frozen_string_literal: true

module Api
  module V1
    class CellsController < Api::V1Controller
      include Deps[cells_query: 'queries.cells']

      before_action :find_cells, only: %i[index]

      SERIALIZER_FIELDS = %w[id q r surface].freeze

      def index
        render json: {
          cells: CellSerializer.new(
            @cells, params: serializer_fields(CellSerializer, SERIALIZER_FIELDS)
          ).serializable_hash
        }, status: :ok
      end

      private

      def find_cells
        @cells = cells_query.resolve(params: params).order(id: :desc)
      end
    end
  end
end
