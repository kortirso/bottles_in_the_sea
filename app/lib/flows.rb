# frozen_string_literal: true

module Flows
  module_function

  HEXAGON_FLOWS = {
    odd: {
      '0' => { r: -1, q: 0 },
      '1' => { r: 0, q: 1 },
      '2' => { r: 1, q: 1 },
      '3' => { r: 1, q: 0 },
      '4' => { r: 1, q: -1 },
      '5' => { r: 0, q: -1 }
    },
    even: {
      '0' => { r: -1, q: 0 },
      '1' => { r: -1, q: 1 },
      '2' => { r: 0, q: 1 },
      '3' => { r: 1, q: 0 },
      '4' => { r: 0, q: -1 },
      '5' => { r: -1, q: -1 }
    }
  }.freeze

  SQUARE_FLOWS = {
    '0' => { r: -1, q: 0 },
    '1' => { r: 0, q: 1 },
    '2' => { r: 1, q: 0 },
    '3' => { r: 0, q: -1 }
  }.freeze

  def cell_changes(direction, column=nil)
    case Rails.configuration.cell_type
    when :square then SQUARE_FLOWS[direction]
    else HEXAGON_FLOWS[column.odd? ? :odd : :even][direction]
    end
  end
end
