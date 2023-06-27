# frozen_string_literal: true

FactoryBot.define do
  factory :searcher do
    name { 'Searcher' }
    cell
    user
  end
end
