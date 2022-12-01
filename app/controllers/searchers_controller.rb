# frozen_string_literal: true

class SearchersController < ApplicationController
  def create
    service_call = Searchers::CreateService.call(
      world_uuid: params[:world_uuid],
      params: searcher_params.merge(user: Current.user),
      cell_params: cell_params
    )
    if service_call.success?
      render json: { redirect_path: root_path }, status: :created
    else
      render json: { errors: service_call.errors }, status: :unprocessable_entity
    end
  end

  private

  def searcher_params
    params.require(:searcher).permit(:name)
  end

  def cell_params
    params.require(:cell).permit(:column, :row)
  end
end
