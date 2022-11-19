class CreateWorlds < ActiveRecord::Migration[7.0]
  def change
    create_table :worlds do |t|
      t.uuid :uuid, null: false, index: { unique: true }
      t.bigint :ticks, null: false, default: 0
      t.string :name, null: false
      t.bigint :lock_version
      t.timestamps
    end

    add_column :cells, :world_id, :bigint, null: false, index: true
  end
end
