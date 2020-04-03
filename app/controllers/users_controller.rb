class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        @list_of_received_friend_requests = current_user.received_friend_requests

        @list_of_friends = current_user.friends

        @special_list = list_of_users_not_friends_with_and_has_not_sent_a_request

        @friend_request = FriendRequest.new
    end

    def show
        @user = User.find_by(:id => params[:id])
        @list_of_posts = @user.posts
        @friend_request = FriendRequest.new
    end

    def already_a_friend(user_id)
        if current_user.friends.find_by(:friend_id => user_id) != nil
            return true
        else
            return false
        end
    end

    def already_sent_a_request(user_id)
        if current_user.sent_friend_requests.find_by(:requestee_id => user_id) != nil
            return true
        else
            return false
        end
    end

    def list_of_users_not_friends_with_and_has_not_sent_a_request
        list_of_friends_ids = current_user.friends.map { |friend| friend.friend_id}
        list_of_friend_requests_ids = current_user.sent_friend_requests.map { |request| request.requestee_id}

        combined_list = list_of_friends_ids.concat(list_of_friend_requests_ids)

        #Add current user's id to the list, so they will not show up in the user's index
        combined_list.push(current_user.id)

        return User.where.not(id: combined_list)
    end

    helper_method :already_a_friend, :already_sent_a_request, :list_of_users_not_friends_with_and_has_not_sent_a_request
end
