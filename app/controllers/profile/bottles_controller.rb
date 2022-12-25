# frozen_string_literal: true

module Profile
  class BottlesController < ApplicationController
    before_action :find_bottles, only: %i[index]

    def index; end

    private

    def find_bottles
      @bottles = Current.user.fish_out_bottles
    end
  end
end
