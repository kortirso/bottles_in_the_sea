# frozen_string_literal: true

module Flows
  class TickService
    prepend ApplicationService

    def initialize(bottles_move_service: Bottles::MoveService.new)
      @bottles_move_service = bottles_move_service
    end

    def call
      ActiveRecord::Base.transaction do
        Bottle
          .joins(:cell)
          .where(cells: { surface: Cell::WATER })
          .find_each { |bottle| @bottles_move_service.call(bottle: bottle) }
      end
    end
  end
end
