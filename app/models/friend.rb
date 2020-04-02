class Friend < ApplicationRecord
    belongs_to :user

    validate :cannot_be_friends_with_yourself

    validates :user_id, presence: true,
        uniqueness: { scope: :friend_id,
            message: "can only be friends with someone else once" }
    validates :friend_id, presence: true

    private

        def cannot_be_friends_with_yourself
            if user_id == friend_id
                errors.add(:friend_id, "cannot be friends with yourself")
            end
        end
end
