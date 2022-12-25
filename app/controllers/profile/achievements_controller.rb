# frozen_string_literal: true

module Profile
  class AchievementsController < ApplicationController
    before_action :find_achievements, only: %i[index]

    def index; end

    private

    def find_achievements
      @achievements = Current.user.kudos_users_achievements.order(updated_at: :desc)
    end
  end
end
