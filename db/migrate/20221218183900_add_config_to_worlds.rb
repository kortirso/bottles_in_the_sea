class AddConfigToWorlds < ActiveRecord::Migration[7.0]
  def change
    add_column :worlds, :cell_type, :integer, null: false, default: 0
    add_column :worlds, :map_size, :jsonb, null: false, default: {}
  end
end
