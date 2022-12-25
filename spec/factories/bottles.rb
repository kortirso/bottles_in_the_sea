# frozen_string_literal: true

FactoryBot.define do
  factory :bottle do
    created_at_tick { 0 }
    association :cell
    association :start_cell, factory: :cell

    trait :moderated do
      moderated_at { DateTime.now }
    end
  end
end
