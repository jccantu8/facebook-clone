class FriendRequest < ApplicationRecord
    #Optional argument was neccessary because when submitting a friend request,
    #user object was trying to be validated and it doesn't exist.
    belongs_to :user, optional: true

    validates :requestor_id, presence: true,
        uniqueness: { scope: :requestee_id,
            message: "can only send one friend request to someone else" },
        exclusion: { in: ->(friendrequest) { [friendrequest.requestee_id] }, # not sure about this syntax
            message: "cannot send a friend request to yourself"} 
    validates :requestee_id, presence: true
end
