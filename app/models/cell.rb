# frozen_string_literal: true

class Cell < ApplicationRecord
  include Uuidable

  WATER = 'water'
  GROUND = 'ground'

  belongs_to :world

  has_many :bottles, dependent: :destroy
  has_many :searchers, dependent: :nullify

  enum surface: { WATER => 0, GROUND => 1 }
end
