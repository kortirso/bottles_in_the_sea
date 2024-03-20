# frozen_string_literal: true

class Bottle < ApplicationRecord
  BORDEAUX = 'bordeaux'
  BURGUNDY = 'burgundy'

  belongs_to :cell, optional: true
  belongs_to :start_cell, class_name: 'Cell'
  belongs_to :end_cell, class_name: 'Cell', optional: true
  belongs_to :user, optional: true
  belongs_to :fish_out_user, class_name: 'User', optional: true

  has_many_attached :files

  scope :moderated, -> { where.not(moderated_at: nil) }
  scope :finished, -> { where.not(end_cell_id: nil) }
  scope :not_finished, -> { where(end_cell_id: nil) }
  scope :available_for_catch, -> { where(fish_out_user_id: nil) }

  enum form: { BORDEAUX => 0, BURGUNDY => 1 }

  def can_move?
    cell.water? && end_cell_id.nil?
  end

  def can_be_catched?
    cell.ground? && end_cell_id.present?
  end

  def moderated?
    !moderated_at.nil?
  end

  def sailing_duration
    return fish_out_at_tick - created_at_tick if fish_out_at_tick

    start_cell.world.ticks - created_at_tick
  end
end
