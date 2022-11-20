class CreateSearchers < ActiveRecord::Migration[7.0]
  def change
    create_table :searchers do |t|
      t.uuid :uuid, null: false, index: { unique: true }
      t.string :name, null: false
      t.bigint :user_id, null: false, index: true
      t.bigint :cell_id, index: true
      t.timestamps
    end
  end
end
