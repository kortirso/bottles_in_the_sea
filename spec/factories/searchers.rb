# frozen_string_literal: true

FactoryBot.define do
  factory :searcher do
    name { 'Searcher' }
    association :cell
    association :user
  end
end
