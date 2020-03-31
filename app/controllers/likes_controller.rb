class LikesController < ApplicationController

    def create
        #disallow liking same post more than once
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
        Like.find_by(:user_id => current_user.id, :post_id => params[:post_id]).destroy
        flash[:success] = "Like destroyed."
        redirect_to root_url
    end

    private

        def like_params
            params.permit(:post_id)
        end
end
