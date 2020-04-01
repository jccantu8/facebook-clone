require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:John)
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
end
