require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:John)
    @post = posts(:ExamplePost)
    @like = Like.new(:user_id => @user.id, :post_id => @post.id)
  end

  test "like should be valid" do
    assert @like.valid?
  end

  test "user id should be present" do
    @like.user_id = ''
    assert_not @like.valid?
  end

  test "post id should be present" do
    @like.post_id = ''
    assert_not @like.valid?
  end

  test "cannot like the same post more than once" do
    @like.save
    @like_duplicate = @like.dup
    assert_not @like_duplicate.valid?
  end
end
