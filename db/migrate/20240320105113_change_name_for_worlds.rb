class ChangeNameForWorlds < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      remove_column :worlds, :name
      add_column :worlds, :name, :jsonb, null: false, default: {}
    end
  end
end
