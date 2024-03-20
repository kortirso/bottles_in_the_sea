# frozen_string_literal: true

module Api
  module V1
    class SearchersController < Api::V1Controller
      include Deps[create_form: 'forms.searchers.create']

      SERIALIZER_FIELDS = %w[id name].freeze

      def create
        case create_form.call(params: searcher_params.merge(user: Current.user), cell_params: cell_params)
        in { errors: errors } then render json: { errors: errors }, status: :unprocessable_entity
        in { result: result }
          render json: {
            searcher: SearcherSerializer.new(
              result, params: serializer_fields(SearcherSerializer, SERIALIZER_FIELDS)
            ).serializable_hash
          }, status: :created
        end
      end

      private

      def searcher_params
        params.require(:searcher).permit(:name)
      end

      def cell_params
        params.require(:cell).permit(:column, :row, :world_id)
      end
    end
  end
end
