# frozen_string_literal: true

module Worlds
  class MassTickJob < ApplicationJob
    queue_as :default

    def perform
      World.pluck(:id).each do |id|
        Worlds::TickJob.perform_later(id: id)
      end
    end
  end
end
