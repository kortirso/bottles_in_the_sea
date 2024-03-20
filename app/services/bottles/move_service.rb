# frozen_string_literal: true

module Bottles
  class MoveService
    FULL_POSSIBILITY = 100

    def call(bottle:)
      return unless bottle.can_move?

      current_cell = bottle.cell
      flow_direction = select_flow_direction(current_cell.flows)
      return if flow_direction.nil?

      map_size = find_map_size(current_cell)
      destination_cell = find_destination_cell(map_size, current_cell, flow_direction[0])
      update_bottle(bottle, destination_cell)
    end

    private

    def select_flow_direction(flows)
      random_value = rand(1..FULL_POSSIBILITY)
      checked_chances = 0
      flows.find { |_, chance|
        checked_chances += chance
        random_value <= checked_chances
      }
    end

    def find_destination_cell(map_size, current_cell, flow_direction)
      coordinates_change = Flows.cell_changes(
        cell_type: current_cell.world,
        direction: flow_direction,
        column: current_cell.q
      )
      q = find_new_q_coordinate(map_size, current_cell, coordinates_change)
      q, r = find_new_r_coordinate(map_size, current_cell, coordinates_change, q)

      Cell.find_by(q: q, r: r)
    end

    def update_bottle(bottle, destination_cell)
      # commento: bottles.cell_id, bottles.end_cell_id
      bottle.update!(
        cell: destination_cell,
        end_cell: destination_cell.ground? ? destination_cell : nil
      )
    end

    def find_new_q_coordinate(map_size, current_cell, coordinates_change)
      new_coordinate = current_cell[:q] + coordinates_change[:q]
      # -1 coordinate is equal maximum map size coordinate from another side of map
      return map_size[:q] if new_coordinate.negative?
      # max+1 coordinate is equal 0 coordinate from another side of map
      return 0 if new_coordinate > map_size[:q]

      new_coordinate
    end

    def find_new_r_coordinate(map_size, current_cell, coordinates_change, column)
      new_coordinate = current_cell[:r] + coordinates_change[:r]
      # north pole coordinates changing
      return [q_from_another_side(map_size, column), 0] if new_coordinate.negative?
      # south pole coordinates changing
      return [q_from_another_side(map_size, column), map_size[:r]] if new_coordinate > map_size[:r]

      [column, new_coordinate]
    end

    # for poles column change is half of full size
    def q_from_another_side(map_size, column)
      column + (map_size[:q] / 2)
    end

    def find_map_size(current_cell)
      current_cell.world.map_size.with_indifferent_access
    end
  end
end
