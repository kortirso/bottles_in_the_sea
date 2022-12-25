# frozen_string_literal: true

module Bottles
  class CreateJob < ApplicationJob
    prepend RailsEventStore::AsyncHandler

    queue_as :default

    def perform(event)
      bottle = Bottle.find_by(uuid: event.data.fetch(:bottle_uuid))
      return unless bottle

      Achievement.award(:bottle_create, bottle)
    end
  end
end
