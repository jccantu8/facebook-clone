class UsersController < ApplicationController
    def index
        #list users that current user is not friends with and has not sent a request to
        @list_of_received_friend_requests = current_user.received_friend_requests

        @list_of_friends = current_user.friends
    end

    def show
        @user = User.find_by(:id => params[:id])
        @list_of_posts = @user.posts
        @friend_request = FriendRequest.new
    end
end
