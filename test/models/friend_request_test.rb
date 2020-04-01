require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  def setup
    @user = users(:John)
    @user2 = users(:Mike)
    @friend_request = FriendRequest.new(:requestor_id => @user.id, :requestee_id => @user2.id)
  end

  test "like should be valid" do
    assert @friend_request.valid?
  end

  test "requestor id should be present" do
    @friend_request.requestor_id = ''
    assert_not @friend_request.valid?
  end

  test "requestee id should be present" do
    @friend_request.requestee_id = ''
    assert_not @friend_request.valid?
  end

  test "cannot send the same friend request more than once" do
    @friend_request.save
    @friend_request_duplicate = @friend_request.dup
    assert_not @friend_request_duplicate.valid?
  end

  test "cannot send a friend request to yourself" do
    @new_friend_request = FriendRequest.new(:requestor_id => @user.id, :requestee_id => @user.id)
    assert_not @new_friend_request.valid?
  end

  ##add test to check cant add someone who added you
end
