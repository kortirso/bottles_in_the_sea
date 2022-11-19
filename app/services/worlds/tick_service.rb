# frozen_string_literal: true

module Worlds
  class TickService
    prepend ApplicationService

    def initialize(bottles_move_service: Bottles::MoveService.new)
      @bottles_move_service = bottles_move_service
    end

    def call(world:)
      @world = world

      ActiveRecord::Base.transaction do
        update_world_tick
        move_bottles
      end
    rescue ::ActiveRecord::StaleObjectError => _e
      Worlds::TickService.call(world: @world)
    end

    private

    def move_bottles
      Bottle
        .joins(:cell)
        .where(cells: { surface: Cell::WATER, world_id: @world.id })
        .find_each { |bottle| @bottles_move_service.call(bottle: bottle) }
    end

    def update_world_tick
      @world.update!(ticks: @world.ticks + 1)
    end
  end
end
