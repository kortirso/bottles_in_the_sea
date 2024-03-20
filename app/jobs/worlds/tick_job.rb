# frozen_string_literal: true

module Worlds
  class TickJob < ApplicationJob
    queue_as :default

    def perform(id:)
      BottlesInTheSea::Container['services.worlds.tick'].call(world_id: id)
    end
  end
end
