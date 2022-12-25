class AddModeratedAtToBottles < ActiveRecord::Migration[7.0]
  def change
    add_column :bottles, :moderated_at, :datetime
  end
end
