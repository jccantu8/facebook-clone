require "test_helper"

class PostsControllerTest  < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:John)
    @friend = users(:Mike)
    @mypost = Post.find_by(:user_id => @user.id)
    @hispost = Post.find_by(:user_id => @friend.id)
    @friend1 = @user.friends.create(:friend_id => @friend.id)
    @friend2 = @friend.friends.create(:friend_id => @user.id)
    @mylist = list_of_posts_from_me_and_my_friends(@user)
    @otherUser = users(:Mary)

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
  test "should be able to get show and display user's post info" do
    sign_in @user
    get user_post_url(:user_id => @user.id, :id => @mypost.id)
    assert_response :success
    assert_select ".postShow .postTitle", text: "#{@mypost.title}"
    assert_select ".postShow .name", text: "Author: #{@user.name}"
    assert_select ".postShow .content", text: "#{@mypost.content}"
    assert_select ".postShow .likeTitle", text: "Likes"
    assert_select ".postShow .likes .name", text: "#{@friend.name}"
    assert_select ".postShow .commentTitle", text: "Comments"
    assert_select ".postShow .comments .comment", text: "#{@friend.name} said: #{@mypost.comments.first.content}"
  end

  test "should be able to delete post" do
    sign_in @user
    get user_post_url(:user_id => @user.id, :id => @mypost.id)
    assert_response :success
    assert_select ".postShow .deletePost", text: "Delete Post"
    assert_difference 'Post.count', -1 do
      delete user_post_path(:user_id => @user.id, :id => @user.posts.first.id)
    end
  end

  test "should be able to like and unlike a post" do
    sign_in @otherUser
    get user_post_url(:user_id => @user.id, :id => @mypost.id)
    assert_response :success
    assert_select ".postShow .like", text: "Like"
    assert_difference 'Like.count', 1 do
      post likes_path(:user_id => @otherUser.id, :post_id => @mypost.id)
    end
    get user_post_url(:user_id => @user.id, :id => @mypost.id)
    assert_response :success
    assert_select ".postShow .unlike", text: "Unlike"
    assert_difference 'Like.count', -1 do
      delete like_path(:post_id => @mypost.id, :id => @otherUser.id)
    end
  end

  test "should be able to make a comment on a post and delete it" do
    sign_in @otherUser
    get user_post_url(:user_id => @user.id, :id => @mypost.id)
    assert_response :success
    assert_difference 'Comment.count', 1 do
      post comments_path, params: { comment: { content: "test comment", :post_id => @mypost.id } }
    end
    get user_post_url(:user_id => @user.id, :id => @mypost.id)
    assert_response :success
    assert_select ".postShow .deleteComment", text: "Delete Comment"
    assert_difference 'Comment.count', -1 do
      delete comment_path(:user_id => @user.id, :post_id => @mypost.id, :id => @otherUser.comments.first.id)
    end
  end

end
