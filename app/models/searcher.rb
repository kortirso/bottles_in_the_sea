# frozen_string_literal: true

class Searcher < ApplicationRecord
  belongs_to :user
  belongs_to :cell, optional: true
end
