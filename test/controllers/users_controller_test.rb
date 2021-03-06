require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:John)
    @friend = users(:Mike)
    @otherUser = users(:Mary)
    @otherUser2 = users(:Robert)

    @otherUser.sent_friend_requests.create(:requestee_id => @user.id)

    @friend1 = @user.friends.create(:friend_id => @friend.id)
    @friend2 = @friend.friends.create(:friend_id => @user.id)
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to new_user_session_url
  end

  test "should redirect show when not logged in" do
    get user_path(@user.id)
    assert_redirected_to new_user_session_url
  end

  test "should get new" do
    get new_user_registration_path
    assert_response :success
  end

  #Index
  test "should get index and display received friend request" do
    sign_in @user
    get users_url
    assert_response :success
    assert_select ".userIndex .friendRequestsTitle", text: "Received Friend Requests"
    assert_select ".userIndex .friendRequests .user .name", text: "#{@otherUser.name}"
  end

  test "should get index and display friends" do
    sign_in @user
    get users_url
    assert_response :success
    assert_select ".userIndex .friendsTitle", text: "Friends"
    assert_select ".userIndex .friends .name", text: "#{@friend.name}"
  end

  test "should get index and display other users" do
    sign_in @user
    get users_url
    assert_response :success
    assert_select ".userIndex .otherUsersTitle", text: "Other Users"
    assert_select ".userIndex .otherUsers .user .name", text: "#{@otherUser2.name}"
  end

  #show
  test "should get show and display user's profile info" do
    sign_in @user
    get user_url(:id => @user.id)
    assert_response :success
    assert_select ".userShow .pageTitle", text: "#{@user.name}"

    @user.posts.each do |x|
      assert_select ".userShow .posts .post .title", text: "#{x.title}"
      assert_select ".userShow .posts .post .content", text: "#{x.content}"
    end
  end

  test "should be able to accept friend request and become friends" do
    sign_in @user
    get users_url
    assert_response :success
    assert_select ".userIndex .friendRequests .acceptRequest", text: "Accept"
    assert_difference ->{ FriendRequest.count } => -1, ->{ Friend.count } => 2 do
      post friends_path, params: { friend_id: @otherUser.id, requestee_id: @user.id }
    end
  end

  test "should be able to decline friend request" do
    sign_in @user
    get users_url
    assert_response :success
    assert_select ".userIndex .friendRequests .declineRequest", text: "Decline"
    assert_difference 'FriendRequest.count', -1 do
      delete friend_request_path(id: @otherUser.sent_friend_requests.first.id, requestor_id: @otherUser.id, requestee_id: @user.id)
    end
  end

  test "should be able to delete a friend" do
    sign_in @user
    get users_url
    assert_response :success
    assert_select ".userIndex .friends .deleteFriend", text: "Delete friend"
    assert_difference 'Friend.count', -2 do
      delete friend_path( id: @friend.friends.first.id , user_id: @user.id, friend_id: @friend.id)
    end
  end

  test "should be able to display other users that you are not friends with" do
    sign_in @user
    get users_url
    assert_response :success
    assert_select ".userIndex .otherUsers .name", text: "#{@otherUser2.name}"
  end
end
