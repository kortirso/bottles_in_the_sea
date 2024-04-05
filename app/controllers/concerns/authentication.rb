# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_user
  end

  private

  def current_user; end

  def authenticate
    return if Current.user

    authentication_error
  end
end
