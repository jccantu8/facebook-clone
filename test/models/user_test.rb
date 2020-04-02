require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Jim", email: "use@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ''
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = 'a' * 31
    assert_not @user.valid?
  end

  test "names without letters should not work" do
    bad_names = ['1', '/', '#', '%', '$', '@', '!', '^', '*', '&']

    bad_names.each do |name|
      @user.name = name
      assert_not @user.valid?
    end
  end

  test "email should be present" do
    @user.email = ''
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = 'a' * 256
    assert_not @user.valid?
  end

  test "emails should be unique" do
    duplicate_user =  @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present" do
    @user.password = ''
    assert_not @user.valid?
  end

  test "password should not be too long" do
    @user.password = 'a' * 31
    assert_not @user.valid?
  end

  test "certain emails should not work" do
    bad_emails = ["user@example,com", "user_at.org", 
                  "user.name@example.", "foo@bar_baz.com", "foo@bar+baz.com"]

    bad_emails.each do |address|
      @user.email = address
      assert_not @user.valid?
    end
  end
end
