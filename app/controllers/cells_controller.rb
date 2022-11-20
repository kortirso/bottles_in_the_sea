# frozen_string_literal: true

class CellsController < ApplicationController
  skip_before_action :authenticate, only: %i[index]
  skip_before_action :check_email_confirmation, only: %i[index]
  before_action :find_cells

  def index
    render json: {
      cells: CellSerializer.new(@cells).serializable_hash
    }, status: :ok
  end

  private

  def find_cells
    @cells = World.find_by!(uuid: params[:world_uuid]).cells.ground.order(r: :asc, q: :asc)
  end
end
