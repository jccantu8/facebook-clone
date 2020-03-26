class FriendRequestsController < ApplicationController
    def create
        @friend_request = current_user.sent_friend_requests.build(friend_request_params)
        
        if @friend_request.save
            flash[:success] = "Friend request sent!"
            redirect_to root_url
        else
            flash[:error] = "An error occurred."
            redirect_to root_url
        end
    end

    def destroy
        #check if user is requestor or requestee
        #find the friend_request and .destroy it
        #flash[:success] = "Friend request destroyed."
        #redirect_to root_url
    end

    private

        def friend_request_params
            params.require(###).permit(requestor_id, requestee_id)
        end
end
