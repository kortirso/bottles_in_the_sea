class CreateBottles < ActiveRecord::Migration[7.0]
  def change
    create_table :bottles do |t|
      t.uuid :uuid, null: false, index: { unique: true }
      t.bigint :user_id, index: true
      t.bigint :fish_out_user_id, index: true
      t.bigint :cell_id, index: true
      t.timestamps
    end
  end
end
