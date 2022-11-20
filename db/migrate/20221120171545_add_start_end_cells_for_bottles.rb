class AddStartEndCellsForBottles < ActiveRecord::Migration[7.0]
  def change
    add_column :bottles, :start_cell_id, :bigint, null: false, index: true
    add_column :bottles, :end_cell_id, :bigint, index: true
  end
end
