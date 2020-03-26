class CommentsController < ApplicationController
    def create
        @comment = current_user.comments.build(comment_params)

        if @comment.save
            flash[:success] = "Comment posted!"
            redirect_to root_url
        else
            flash[:error] = "An error occurred."
            redirect_to root_url
        end       
    end

    def destroy
        #comment author and post author can destroy it
        #find the comment and .destroy it
        #flash[:success] = "Comment destroyed."
        #redirect_to root_url
    end

    private

        def comment_params
            params.require(###).permit(:content, :post_id)
end
