# frozen_string_literal: true

class Bottle < ApplicationRecord
  include Uuidable

  belongs_to :cell
  belongs_to :user, optional: true
  belongs_to :fish_out_user, class_name: 'User', optional: true
end
