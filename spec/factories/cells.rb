# frozen_string_literal: true

FactoryBot.define do
  factory :cell do
    q { 0 }
    r { 0 }
    surface { Cell::WATER }
    flows { { 0 => 20, 1 => 15, 2 => 15, 3 => 20, 4 => 15, 5 => 15 } }
    world

    trait :ground do
      surface { Cell::GROUND }
    end
  end
end
