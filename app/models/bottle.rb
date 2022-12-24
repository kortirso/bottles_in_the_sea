# frozen_string_literal: true

class Bottle < ApplicationRecord
  include Uuidable

  BORDEAUX = 'bordeaux'
  BURGUNDY = 'burgundy'

  belongs_to :cell, optional: true
  belongs_to :start_cell, class_name: 'Cell'
  belongs_to :end_cell, class_name: 'Cell', optional: true
  belongs_to :user, optional: true
  belongs_to :fish_out_user, class_name: 'User', optional: true

  has_many_attached :files

  enum form: { BORDEAUX => 0, BURGUNDY => 1 }

  def can_move?
    cell.water?
  end
end
