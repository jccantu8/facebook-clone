class CommentsController < ApplicationController
    before_action :authenticate_user!

    def create
        @comment = current_user.comments.build(comment_params)

        if @comment.save
            flash[:success] = "Comment posted!"
            redirect_to user_post_url(:user_id => current_user.id, :id => @comment.post_id)
        else
            flash[:error] = "An error occurred."
            redirect_to user_post_url(:user_id => current_user.id, :id => @comment.post_id)
        end       
    end

    def destroy
        #comment author and post author can destroy it
        Comment.find_by(:id => params[:id]).destroy
        flash[:success] = "Comment deleted."
        redirect_to user_post_url(:user_id => current_user.id, :id => params[:post_id])
    end

    private

        def comment_params
            params.require(:comment).permit(:content, :post_id)
        end
end
