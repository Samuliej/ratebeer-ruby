class AddUserIndexBasedOnUsername < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :username
  end
end
