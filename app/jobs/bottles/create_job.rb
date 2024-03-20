# frozen_string_literal: true

module Bottles
  class CreateJob < ApplicationJob
    queue_as :default

    def perform(id:)
      bottle = Bottle.find_by(id: id)
      return unless bottle

      Achievement.award(:bottle_create, bottle)
    end
  end
end
