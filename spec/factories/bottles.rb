# frozen_string_literal: true

FactoryBot.define do
  factory :bottle do
    created_at_tick { 0 }
    cell
    start_cell factory: %i[cell]

    trait :moderated do
      moderated_at { DateTime.now }
    end
  end
end
