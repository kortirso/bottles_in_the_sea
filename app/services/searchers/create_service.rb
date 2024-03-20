# frozen_string_literal: true

module Searchers
  class CreateService
    prepend ApplicationService

    def call(world_id:, params:, cell_params:)
      return if find_world(world_id) && failure?
      return if find_cell(cell_params) && failure?
      return if validate_searchers_amount(params[:user]) && failure?

      Searcher.create(params.merge(cell: @cell))
    end

    private

    def find_world(world_id)
      @world = World.find_by(id: world_id)
      fail!('World is not found') unless @world
    end

    def find_cell(cell_params)
      @cell = @world.cells.ground.find_by(q: cell_params[:column].to_i, r: cell_params[:row].to_i)
      fail!('Cell is not found') unless @cell
    end

    def validate_searchers_amount(user)
      fail!('Too many searchers') if user.searchers.count.positive?
    end
  end
end
