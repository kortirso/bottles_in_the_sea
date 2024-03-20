# frozen_string_literal: true

module Bottles
  class CatchService
    def call(bottle:, success_chance: 20)
      return unless bottle.can_be_catched?
      return unless fish_out_succeed?(success_chance)

      lucker_id = Searcher.where(cell_id: bottle.cell_id).pluck(:user_id).sample
      return unless lucker_id

      # commento: bottles.cell_id, bottles.fish_out_user_id, bottles.fish_out_at_tick
      bottle.update!(
        cell: nil,
        fish_out_user_id: lucker_id,
        fish_out_at_tick: bottle.cell.world.ticks
      )
    end

    private

    # default succeed chance is 20%
    def fish_out_succeed?(success_chance)
      return false if success_chance.zero?

      rand(1..100) > 100 - success_chance
    end
  end
end
