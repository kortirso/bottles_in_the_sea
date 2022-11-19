# frozen_string_literal: true

class World < ApplicationRecord
  include Uuidable

  has_many :cells, dependent: :destroy
  has_many :bottles, through: :cells
end
