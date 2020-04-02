class FriendRequest < ApplicationRecord
    #Optional argument was neccessary because when submitting a friend request,
    #user object was trying to be validated and it doesn't exist.
    belongs_to :user, optional: true

    validate :cannot_add_yourself, :cannot_add_someone_who_has_added_you

    validates :requestor_id, presence: true,
        uniqueness: { scope: :requestee_id,
            message: "can only send one friend request to someone else" }
    validates :requestee_id, presence: true

    private

        def cannot_add_yourself
            if requestor_id == requestee_id
                errors.add(:requestor_id, "cannot send a friend request to yourself")
            end
        end

        def cannot_add_someone_who_has_added_you
            if FriendRequest.find_by(:requestor_id => requestee_id, :requestee_id => requestor_id) != nil
                errors.add(:requestor_id, "cannot send a friend request to someone who has added you")
            end
        end
end
