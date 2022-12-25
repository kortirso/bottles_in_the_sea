# frozen_string_literal: true

module Profile
  class SearchersController < ApplicationController
    before_action :find_searchers, only: %i[index]

    def index; end

    private

    def find_searchers
      @searchers = Current.user.searchers.includes(:cell)
    end
  end
end
