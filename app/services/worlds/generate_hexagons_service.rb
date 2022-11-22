# frozen_string_literal: true

module Worlds
  # service for generating predefined hexagons values for rendering world map
  class GenerateHexagonsService
    prepend ApplicationService

    HEXAGON_FILE_PATH = 'app/javascript/data/hexagons.json'
    HEXAGON_HEIGHT = 34.6
    HEXAGON_HALF_HEIGHT = 17.3

    def initialize
      @map_size = Rails.configuration.map_size
      @cells = World.first.cells
    end

    def call
      generate_hexagon_values
        .then { |data| save_to_file(data) }
    end

    private

    def generate_hexagon_values
      hexagons = []
      (0..@map_size[:r]).each do |row|
        (0..@map_size[:q]).each do |column|
          cell = @cells.find { |cell| cell.r == row && cell.q == column }
          hexagons.push(generate_hexagon(row, column, cell.surface))
        end
      end
      hexagons
    end

    def generate_hexagon(row, column, surface)
      start_x = column * 30
      even_column = column.even?
      start_y = even_column ? (row * HEXAGON_HEIGHT).round(1) : odd_row_middle_y(row)

      {
        row: row,
        column: column,
        svg_path: svg(start_x, start_y),
        center_x: start_x + 20,
        center_y: even_column ? odd_row_middle_y(row) : ((row + 1) * HEXAGON_HEIGHT).round(1),
        surface: surface
      }
    end

    def odd_row_middle_y(row)
      ((row * HEXAGON_HEIGHT) + HEXAGON_HALF_HEIGHT).round(1)
    end

    # rubocop: disable Layout/LineLength
    def svg(start_x, start_y)
      "M#{start_x + 10} #{start_y} #{start_x} #{(start_y + HEXAGON_HALF_HEIGHT).round(1)} #{start_x + 10} #{(start_y + HEXAGON_HEIGHT).round(1)} #{start_x + 30} #{(start_y + HEXAGON_HEIGHT).round(1)} #{start_x + 40} #{(start_y + HEXAGON_HALF_HEIGHT).round(1)} #{start_x + 30} #{start_y} Z"
    end
    # rubocop: enable Layout/LineLength

    def save_to_file(data)
      File.write(HEXAGON_FILE_PATH, data.to_json)
    end
  end
end
