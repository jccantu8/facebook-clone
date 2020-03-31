class FriendRequest < ApplicationRecord
    #Optional argument was neccessary because when submitting a friend request,
    #user object was trying to be validated and it doesn't exist.
    belongs_to :user, optional: true
end
