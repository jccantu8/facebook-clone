require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:John)
  end

  test "should be able to create a comment" do
    
  end

  test "should be able to destroy a comment" do

  end
end
