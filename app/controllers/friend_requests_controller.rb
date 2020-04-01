class FriendRequestsController < ApplicationController
    before_action :authenticate_user!

    # cant send a friend request to someone who sent you one

    def create
        @friend_request = current_user.sent_friend_requests.build(friend_request_params)
        
        if @friend_request.save
            flash[:success] = "Friend request sent!"
            redirect_to users_url
        else
            flash[:error] = "An error occurred."
            redirect_to root_url
        end
    end

    def destroy
        #check if user is requestor or requestee
        FriendRequest.find_by(:requestor_id => params[:requestor_id], :requestee_id => current_user.id).destroy
        flash[:success] = "Friend request destroyed."
        redirect_to users_url
    end

    private

        def friend_request_params
            params.require(:friend_request).permit(:requestee_id)
        end
        
end
