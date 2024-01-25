# frozen_string_literal: true

module Bottles
  class CreateJob < ApplicationJob
    queue_as :default

    def perform(uuid:)
      bottle = Bottle.find_by(uuid: uuid)
      return unless bottle

      Achievement.award(:bottle_create, bottle)
    end
  end
end
