# frozen_string_literal: true

module Searchers
  class CreateForm
    def call(params:, cell_params:)
      cell = find_cell(cell_params)
      return { errors: ['Cell is not found'] } unless cell

      error = validate_searchers_amount(params[:user])
      return { errors: [error] } if error

      { result: Searcher.create!(params.merge(cell: cell)) }
    end

    private

    def find_cell(cell_params)
      Cell.ground.find_by(
        q: cell_params[:column].to_i,
        r: cell_params[:row].to_i,
        world_id: cell_params[:world_id]
      )
    end

    def validate_searchers_amount(user)
      'Too many searchers' if user.searchers.count.positive?
    end
  end
end
