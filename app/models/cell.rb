# frozen_string_literal: true

class Cell < ApplicationRecord
  include Uuidable

  WATER = 'water'
  GROUND = 'ground'

  has_many :bottles, dependent: :destroy

  enum surface: { WATER => 0, GROUND => 1 }
end
