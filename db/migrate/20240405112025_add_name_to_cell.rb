class AddNameToCell < ActiveRecord::Migration[7.1]
  def change
    add_column :cells, :name, :jsonb, null: false, default: {}
  end
end
