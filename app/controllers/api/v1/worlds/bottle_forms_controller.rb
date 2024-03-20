# frozen_string_literal: true

module Api
  module V1
    module Worlds
      class BottleFormsController < Api::V1Controller
        before_action :find_world

        def index
          render json: { bottle_forms: Bottle.forms.keys }, status: :ok
        end

        private

        def find_world
          @world = World.find(params[:world_id])
        end
      end
    end
  end
end
