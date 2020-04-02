require 'test_helper'

class FriendTest < ActiveSupport::TestCase
  def setup
    @user = users(:John)
    @user2 = users(:Mike)
    @friends = Friend.new(:user_id => @user.id, :friend_id => @user2.id)
  end

  test "friends should be valid" do
    assert @friends.valid?
  end

  test "user id should be present" do
    @friends.user_id = ''
    assert_not @friends.valid?
  end

  test "friend id should be present" do
    @friends.friend_id = ''
    assert_not @friends.valid?
  end

  test "cannot be friends with someone else more than once" do
    @friends.save
    @friends_duplicate = @friends.dup
    assert_not @friends_duplicate.valid?
  end

  test "cannot be friends with yourself" do
    @new_friends = Friend.new(:user_id => @user.id, :friend_id => @user.id)
    assert_not @new_friends.valid?
  end

end
