# frozen_string_literal: true

module Bottles
  class CreateService
    prepend ApplicationService

    def call(world_uuid:, params:, cell_params:)
      return if find_world(world_uuid) && failure?
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

    def find_world(world_uuid)
      @world = World.find_by(uuid: world_uuid)
      fail!('World is not found') unless @world
    end

    def find_cell(cell_params)
      @cell = @world.cells.water.find_by(q: cell_params[:column].to_i, r: cell_params[:row].to_i)
      fail!('Cell is not found') unless @cell
    end

    def publish_created_bottle
      Bottles::CreateJob.perform_later(uuid: @result.uuid)
    end
  end
end
