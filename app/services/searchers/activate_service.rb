# frozen_string_literal: true

module Searchers
  class ActivateService
    prepend ApplicationService

    def initialize(success_chance: 20)
      @success_chance = success_chance
    end

    def call(searcher:)
      searcher.cell.bottles.each do |bottle|
        next unless fish_out_succeed?

        bottle.update!(
          cell: nil,
          fish_out_user: searcher.user
        )
      end
    end

    private

    def fish_out_succeed?
      return false if @success_chance.zero?

      maximum_range_value = 100 / @success_chance
      rand(1..maximum_range_value) == maximum_range_value
    end
  end
end
