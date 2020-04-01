class Like < ApplicationRecord
    belongs_to :user
    belongs_to :post

    validates :post_id, presence: true
    validates :user_id, presence: true, uniqueness: { scope: :post_id,
        message: "can only like a post once" }
end
