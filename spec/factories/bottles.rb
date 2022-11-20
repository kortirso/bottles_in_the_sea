# frozen_string_literal: true

FactoryBot.define do
  factory :bottle do
    created_at_tick { 0 }
    association :cell
    association :start_cell, factory: :cell
  end
end
