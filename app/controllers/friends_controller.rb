class FriendsController < ApplicationController
    def create
        #Friend model uses two records for each friendship.
        @friend1 = current_user.friends.build(friend_params)
        @friend2 = other_user.friends.build

        if @friend1.save && @friend2.save
            flash[:success] = "You are now friends!"
            redirect_to root_url
        else
            flash[:error] = "An error occurred."
            redirect_to root_url
        end
    end

    def destroy
        #make sure current user is logged in
        #find both friend records and .destroy them
        #flash[:success] = "You are no longer friends."
        #redirect_to root_url
    end

    private

        def friend_params
            params.require(###).permit(friend_id)
        end
end
