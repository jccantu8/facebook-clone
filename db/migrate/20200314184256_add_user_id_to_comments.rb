class AddUserIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :user_id, :integer
    add_foreign_key :comments, :users, column: :user_id
  end
end
