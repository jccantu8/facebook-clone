require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:John)
    @post = Post.new(:title => "mytitle", :content => "example content", user_id: @user.id)
  end

  test "post should be valid" do
    assert @post.valid?
  end

  test "title should be present" do
    @post.title = ''
    assert_not @post.valid?
  end

  test "title should not be too long" do
    @post.title = 'a' * 256
    assert_not @post.valid?
  end

  test "content should be present" do
    @post.content = ''
    assert_not @post.valid?
  end

  test "content should not be too long" do
    @post.content = 'a' * 10001
    assert_not @post.valid?
  end
end
