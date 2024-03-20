class AddUsernameToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    safety_assured do
      change_column_null :users, :email, true

      add_column :users, :username, :string

      User.find_each.with_index do |user, index|
        user.update!(username: "user_#{index}")
      end

      add_index :users, :username, unique: true, algorithm: :concurrently
      change_column_null :users, :email, false

      remove_column :worlds, :uuid
      remove_column :searchers, :uuid
      remove_column :cells, :uuid
      remove_column :bottles, :uuid
    end
  end
end
