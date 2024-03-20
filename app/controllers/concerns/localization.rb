# frozen_string_literal: true

module Localization
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
  end

  private

  def set_locale
    locale = params[:locale]&.to_sym
    I18n.locale =
      if I18n.available_locales.include?(locale)
        locale
      else
        I18n.default_locale
      end
  end
end
