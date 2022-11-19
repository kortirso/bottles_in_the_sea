# frozen_string_literal: true

module Bottles
  class MoveService
    prepend ApplicationService

    def call(bottle:)
      return unless bottle.can_move?

      select_flow_direction(bottle.cell.flows)
        .then { |flow_direction| find_destination_cell(bottle.cell, flow_direction) }
        .then { |destination_cell| update_bottle(bottle, destination_cell) }
    end

    private

    def select_flow_direction(flows)
      random_value = rand(flows.values.sum + 1)
      checked_chances = 0
      flows.find { |_, chance|
        checked_chances += chance
        random_value <= checked_chances
      }[0]
    end

    def find_destination_cell(current_cell, flow_direction)
      coordinates_change = Flows.cell_changes(flow_direction, current_cell.q)
      q = find_new_coordinate(current_cell, coordinates_change, :q)
      r = find_new_coordinate(current_cell, coordinates_change, :r)

      Cell.find_by(q: q, r: r)
    end

    def update_bottle(bottle, destination_cell)
      bottle.update(cell: destination_cell)
    end

    def find_new_coordinate(current_cell, coordinates_change, symbol)
      new_coordinate = current_cell[symbol] + coordinates_change[symbol]
      # -1 coordinate is equal maximum map size coordinate from another side of map
      return Rails.configuration.map_size[symbol] if new_coordinate.negative?
      # max+1 coordinate is equal 0 coordinate from another side of map
      return 0 if new_coordinate > Rails.configuration.map_size[symbol]

      new_coordinate
    end
  end
end
