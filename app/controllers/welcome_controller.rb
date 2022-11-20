# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :authenticate
  skip_before_action :check_email_confirmation
  before_action :find_world

  def index; end

  private

  def find_world
    @world = World.first
  end
end
