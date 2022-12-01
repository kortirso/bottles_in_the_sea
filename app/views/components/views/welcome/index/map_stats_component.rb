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
          @world.bottles.joins(:cell).where(cells: { surface: Cell::WATER }).count
        end

        def total_ground_bottles
          @world.bottles.joins(:cell).where(cells: { surface: Cell::GROUND }).count
        end

        def world_ticks
          @world.ticks
        end

        def total_searchers
          @world.searchers.count
        end
      end
    end
  end
end
