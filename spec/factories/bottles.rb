# frozen_string_literal: true

FactoryBot.define do
  factory :bottle do
    association :cell
  end
end
