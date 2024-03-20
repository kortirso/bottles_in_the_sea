# frozen_string_literal: true

FactoryBot.define do
  factory :world do
    name { { en: 'Forgotten Realms', ru: 'Забытые Королевства' } }
  end
end
