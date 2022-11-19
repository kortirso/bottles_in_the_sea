class AddTickstampToBottles < ActiveRecord::Migration[7.0]
  def change
    add_column :bottles, :created_at_tick, :bigint, null: false
    add_column :bottles, :fish_out_at_tick, :bigint
  end
end
