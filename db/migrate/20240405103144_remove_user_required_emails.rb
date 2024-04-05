class RemoveUserRequiredEmails < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_column_null :users, :email, true
    end
  end
end
