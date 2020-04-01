class FriendsController < ApplicationController
    before_action :authenticate_user!

    def create
        # find and destroy friend request
        FriendRequest.find_by(:requestor_id => params[:friend_id], :requestee_id => current_user.id).destroy

        #Friend model uses two records for each friendship.
        @friend1 = current_user.friends.build(:friend_id => params[:friend_id])
        @friend2 = other_user.friends.build(:friend_id => current_user.id)

        if @friend1.save && @friend2.save
            flash[:success] = "You are now friends!"
            redirect_to users_url
        else
            flash[:error] = "An error occurred."
            redirect_to root_url
        end
    end

    def destroy
        #make sure current user is logged in
        Friend.find_by(:user_id => current_user.id, :friend_id => params[:friend_id]).destroy
        Friend.find_by(:user_id => params[:friend_id], :friend_id => current_user.id).destroy
        flash[:success] = "You are no longer friends."
        redirect_to users_url
    end

    private

        def friend_params
            params.permit(:friend_id, :_method, :authenticity_token)
        end

        def other_user
            User.find_by(:id => friend_params[:friend_id])
        end
end
