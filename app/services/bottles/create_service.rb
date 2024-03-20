# frozen_string_literal: true

module Bottles
  class CreateService
    prepend ApplicationService

    def call(world_id:, params:, cell_params:)
      return if find_world(world_id) && failure?
      return if find_cell(cell_params) && failure?

      @result = Bottle.create(
        params.merge(
          created_at_tick: @world.ticks,
          cell: @cell,
          start_cell: @cell
        )
      )
      publish_created_bottle
    end

    private

    def find_world(world_id)
      @world = World.find_by(id: world_id)
      fail!('World is not found') unless @world
    end

    def find_cell(cell_params)
      @cell = @world.cells.water.find_by(q: cell_params[:column].to_i, r: cell_params[:row].to_i)
      fail!('Cell is not found') unless @cell
    end

    def publish_created_bottle
      Bottles::CreateJob.perform_later(id: @result.id)
    end
  end
end
