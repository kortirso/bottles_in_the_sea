class CreateCells < ActiveRecord::Migration[7.0]
  def change
    create_table :cells do |t|
      t.integer :q, null: false, default: 0
      t.integer :r, null: false, default: 0
      t.integer :surface, null: false, default: 0
      t.jsonb :flows, null: false, default: { 0 => 100 }
      t.timestamps
    end
  end
end
