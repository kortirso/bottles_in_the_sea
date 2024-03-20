# frozen_string_literal: true

module Worlds
  class TickService
    include Deps[
      move_service: 'services.bottles.move',
      catch_service: 'services.bottles.catch'
    ]

    def call(world_id:)
      world = World.find_by(id: world_id)
      return unless world

      ActiveRecord::Base.transaction do
        update_tick(world)
        move_bottles(world_id)
        catch_bottles(world_id)
      end
    end

    private

    def update_tick(world)
      world.update!(ticks: world.ticks + 1)
    end

    def move_bottles(world_id)
      Bottle
        .moderated
        .not_finished
        .joins(:cell)
        .where(cells: { surface: Cell::WATER, world_id: world_id })
        .find_each { |bottle| move_service.call(bottle: bottle) }
    end

    def catch_bottles(world_id)
      Bottle
        .finished
        .available_for_catch
        .joins(:cell)
        .where(cells: { surface: Cell::GROUND, world_id: world_id })
        .find_each { |bottle| catch_service.call(bottle: bottle) }
    end
  end
end
