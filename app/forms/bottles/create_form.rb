# frozen_string_literal: true

module Bottles
  class CreateForm
    include Deps[validator: 'validators.users.create']

    def call(params:, cell_params:)
      cell = find_cell(cell_params)
      return { errors: ['Cell is not found'] } unless cell

      result = Bottle.create!(
        params.merge(
          created_at_tick: cell.world.ticks,
          cell: cell,
          start_cell: cell
        )
      )
      publish_created_bottle(result)

      { result: result }
    end

    private

    def find_cell(cell_params)
      Cell.water.find_by(
        q: cell_params[:column].to_i,
        r: cell_params[:row].to_i,
        world_id: cell_params[:world_id]
      )
    end

    def publish_created_bottle(result)
      Bottles::CreateJob.perform_later(id: result.id)
    end
  end
end
