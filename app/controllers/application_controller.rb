# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  append_view_path Rails.root.join('app/views/controllers')

  include Localization

  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found

  # rubocop: disable Lint/UselessMethodDefinition
  # https://github.com/dry-rb/dry-auto_inject/issues/91
  def initialize = super
  # rubocop: enable Lint/UselessMethodDefinition

  def page_not_found
    render template: 'shared/404', status: :not_found, formats: [:html]
  end
end
