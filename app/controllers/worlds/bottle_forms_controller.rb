# frozen_string_literal: true

module Worlds
  class BottleFormsController < ApplicationController
    before_action :find_world

    def index
      render json: { bottle_forms: Bottle.forms.keys }, status: :ok
    end

    private

    def find_world
      @world = World.find_by!(uuid: params[:world_id])
    end
  end
end
