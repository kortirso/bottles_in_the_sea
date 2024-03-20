# frozen_string_literal: true

module Api
  module V1
    class BottlesController < Api::V1Controller
      include Deps[create_form: 'forms.bottles.create']

      SERIALIZER_FIELDS = %w[id form].freeze

      def create
        case create_form.call(params: bottle_params.merge(user: Current.user), cell_params: cell_params)
        in { errors: errors } then render json: { errors: errors }, status: :unprocessable_entity
        in { result: result }
          render json: {
            bottle: BottleSerializer.new(
              result, params: serializer_fields(BottleSerializer, SERIALIZER_FIELDS)
            ).serializable_hash
          }, status: :created
        end
      end

      private

      def bottle_params
        params.require(:bottle).permit(:form, files: [])
      end

      def cell_params
        params.require(:cell).permit(:column, :row, :world_id)
      end
    end
  end
end
