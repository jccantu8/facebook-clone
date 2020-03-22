require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:John)
    @post = posts(:ExamplePost)
    @post.user_id = @user.id
    @comment = Comment.new(:content => "example comment", user_id: @user.id, post_id: @post.id)
  end

  test "comment should be valid" do
    assert @comment.valid?
  end

  test "comment content should be present" do
    @comment.content = ''
    assert_not @comment.valid?
  end

  test "comment content should not be too long" do
    @comment.content = 'a' * 10001
    assert_not @comment.valid?
  end
end