require "test_helper"

class PostsControllerTest  < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:John)
    @friend = users(:Mike)
    @mypost = @user.posts.create(:title => "Test title", :content => "Test content")
    @hispost = @friend.posts.create(:title => "Test title2", :content => "Test content2")
    @mylist = list_of_posts_from_me_and_my_friends(@user)
  end

  test "should redirect index when not logged in" do
    get user_posts_path(@user.id)
    assert_redirected_to new_user_session_url
  end

  test "should redirect new when not logged in" do
    get new_user_post_path(@user.id)
    assert_redirected_to new_user_session_url
  end

  test "should redirect show when not logged in" do
    get user_post_path(:user_id => @user.id, :id => @mypost.id)
    assert_redirected_to new_user_session_url
  end

  #Index

  test "should get index and display title" do
    sign_in @user
    get user_posts_url(:user_id => @user.id)
    assert_response :success
    assert_select ".postIndex .pageTitle", text: "Everyone's Posts"
  end

  test "should display a post from you and your friend" do
    sign_in @user
    get root_url
    assert_response :success

    @mylist.each do |x|
      assert_select ".postIndex .name", text: x.user.name
      assert_select ".postIndex .link", text: x.title
      assert_select ".postIndex .content", text: x.content
    end
  end

  #New

  test "should get new and display title" do
    sign_in @user
    get new_user_post_url(:user_id => @user.id)
    assert_response :success
    assert_select ".postNew .pageTitle", text: "Create a New Post"
  end

  #Create

  test "should be able to make new post" do
    sign_in @user
    get new_user_post_url(:user_id => @user.id)
    assert_response :success
    assert_difference "Post.count", 1 do
      post user_posts_path , params: { post: { title: "new title", content: "new content" } }
    end
  end

  test "should not be able to make a new post without a title" do
    sign_in @user
    get new_user_post_url(:user_id => @user.id)
    assert_response :success
    assert_no_difference "Post.count" do
      post user_posts_path , params: { post: { title: "", content: "new content" } }
    end
  end

  test "should not be able to make a new post without content" do
    sign_in @user
    get new_user_post_url(:user_id => @user.id)
    assert_response :success
    assert_no_difference "Post.count" do
      post user_posts_path , params: { post: { title: "new title", content: "" } }
    end
  end

  #Show
  
end
