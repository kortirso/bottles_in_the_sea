# frozen_string_literal: true

class BottlesController < ApplicationController
  def create
    service_call = Bottles::CreateService.call(
      world_uuid: params[:world_uuid],
      params: bottle_params.merge(user: Current.user),
      cell_params: cell_params
    )
    if service_call.success?
      render json: { redirect_path: root_path }, status: :created
    else
      render json: { errors: service_call.errors }, status: :unprocessable_entity
    end
  end

  private

  def bottle_params
    params.require(:bottle).permit(:form, files: [])
  end

  def cell_params
    params.require(:cell).permit(:column, :row)
  end
end
