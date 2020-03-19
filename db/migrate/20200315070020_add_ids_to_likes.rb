class AddIdsToLikes < ActiveRecord::Migration[6.0]
  def change
    add_column :likes, :user_id, :integer
    add_foreign_key :likes, :users, column: :user_id

    add_column :likes, :post_id, :integer
    add_foreign_key :likes, :posts, column: :post_id
  end
end
