class AddIdsToFriendRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :friend_requests, :requestor_id, :integer
    add_foreign_key :friend_requests, :users, column: :requestor_id

    add_column :friend_requests, :requestee_id, :integer
    add_foreign_key :friend_requests, :users, column: :requestee_id
  end
end
