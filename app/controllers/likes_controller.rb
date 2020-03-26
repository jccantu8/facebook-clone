class LikesController < ApplicationController

    def create
        @like = current_user.likes.build(like_params)

        if @like.save
            flash[:success] = "Liked post!"
            redirect_to root_url
        else
            flash[:error] = "An error occurred."
            redirect_to root_url
        end
    end

    def destroy
        #can only destroy if current_user
        #find the like and .destroy it
        #flash[:success] = "Like destroyed."
        #redirect_to root_url
    end

    private

        def like_params
            params.require(###).permit(post_id)
        end
end
