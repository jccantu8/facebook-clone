ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  #parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def list_of_posts_from_me_and_my_friends(user)
    list_of_friends_ids = user.friends.map { |friend| friend.friend_id}

    combined_list = list_of_friends_ids.push(user.id)

    return Post.where(user_id: combined_list)
  end
end
