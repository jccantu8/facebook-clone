class AddIdsToFriends < ActiveRecord::Migration[6.0]
  def change
    add_column :friends, :user_id, :integer
    add_foreign_key :friends, :users, column: :user_id

    add_column :friends, :friend_id, :integer
    add_foreign_key :friends, :users, column: :friend_id
  end
end
