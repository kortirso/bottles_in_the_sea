# frozen_string_literal: true

module Worlds
  class TickService
    prepend ApplicationService

    def initialize(
      bottles_move_service: Bottles::MoveService.new,
      searchers_activate_service: Searchers::ActivateService.new
    )
      @bottles_move_service = bottles_move_service
      @searchers_activate_service = searchers_activate_service
    end

    def call(world_id:)
      @world = World.find(world_id)
      ActiveRecord::Base.transaction do
        update_world_tick
        move_bottles
        activate_searchers
      end
    rescue ::ActiveRecord::StaleObjectError => _e
      Worlds::TickService.call(world_id: @world.id)
    end

    private

    def update_world_tick
      @world.update!(ticks: @world.ticks + 1)
    end

    def move_bottles
      Bottle
        .moderated
        .joins(:cell)
        .where(cells: { surface: Cell::WATER, world_id: @world.id })
        .find_each { |bottle| @bottles_move_service.call(bottle: bottle) }
    end

    def activate_searchers
      cells_with_bottles = @world.bottles.where.not(end_cell: nil).pluck(:end_cell_id)
      Searcher
        .where(cell_id: cells_with_bottles)
        .find_each { |searcher| @searchers_activate_service.call(searcher: searcher) }
    end
  end
end
