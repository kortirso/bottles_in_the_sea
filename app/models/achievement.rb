# frozen_string_literal: true

class Achievement < Kudos::Achievement
  BOTTLE_CREATE_REQUIREMENTS = {
    1 => 1,
    2 => 25,
    3 => 100
  }.freeze

  award_for :bottle_create do |achievements, bottle|
    user = bottle.user
    return unless user

    achievements.each do |achievement|
      if !user.awarded?(achievement: achievement) && user.bottles.count >= BOTTLE_CREATE_REQUIREMENTS[achievement.rank]
        user.award(achievement: achievement)
      end
    end
  end
end
