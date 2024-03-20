# frozen_string_literal: true

class CellsQuery
  def resolve(relation: Cell.all, params: {})
    relation = relation.where(world_id: params[:world_id]) if params[:world_id].present?
    relation
  end
end
