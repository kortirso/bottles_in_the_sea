class AddFormToBottles < ActiveRecord::Migration[7.0]
  def change
    add_column :bottles, :from, :integer, null: false, default: 0
  end
end
