require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:John)
    @friend = users(:Mike)
    @otherUser = users(:Mary)

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
    assert_select ".userIndex .friendRequests .name", text: "#{@otherUser.name}"
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
    assert_select ".userIndex .otherUsers .name", text: "#{@otherUser.name}"
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

end
