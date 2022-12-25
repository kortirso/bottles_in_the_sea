# frozen_string_literal: true

Rails.configuration.to_prepare do
  Rails.configuration.event_store = event_store = RailsEventStore::Client.new
  # subscribers
  event_store.subscribe(Bottles::CreateJob, to: [Bottles::CreatedEvent])
end
