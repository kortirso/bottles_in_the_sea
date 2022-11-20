# frozen_string_literal: true

module Views
  module Welcome
    module Index
      class MapStatsComponent < ApplicationViewComponent
        def initialize(world:)
          @world = world

          super()
        end

        private

        def total_bottles
          @world.bottles.joins(:cell).where(cells: { surface: Cell::WATER }).size
        end

        def total_ground_bottles
          @world.bottles.joins(:cell).where(cells: { surface: Cell::GROUND }).size
        end

        def world_ticks
          @world.ticks
        end
      end
    end
  end
end
