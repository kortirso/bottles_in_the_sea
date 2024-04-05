# frozen_string_literal: true

class Cell < ApplicationRecord
  WATER = 'water'
  GROUND = 'ground'
  COAST = 'coast'

  belongs_to :world

  has_many :bottles, dependent: :destroy
  has_many :searchers, dependent: :nullify

  enum surface: { WATER => 0, GROUND => 1, COAST => 2 }
end
