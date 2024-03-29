# frozen_string_literal: true

class User < ApplicationRecord
  include ActiveModel::SecurePassword
  include Kudos::Achievementable

  has_secure_password
  has_secure_token :confirmation_token, length: 24
  has_secure_token :restore_token, length: 24

  has_many :bottles, foreign_key: :user_id, dependent: :nullify
  has_many :fish_out_bottles, class_name: 'Bottle', foreign_key: :fish_out_user_id, dependent: :nullify
  has_many :searchers, dependent: :destroy

  has_one :users_session, class_name: 'Users::Session', dependent: :destroy

  scope :not_confirmed, -> { where(confirmed_at: nil) }

  enum role: { regular: 0, admin: 1 }

  def confirmed?
    confirmed_at.present?
  end
end
