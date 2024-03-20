# frozen_string_literal: true

class World < ApplicationRecord
  HEXAGON = 'hexagon'
  SQUARE = 'square'

  has_many :cells, dependent: :destroy
  has_many :bottles, through: :cells
  has_many :searchers, through: :cells

  enum cell_type: { HEXAGON => 0, SQUARE => 1 }
end
