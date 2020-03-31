class PostsController < ApplicationController
    def index
        #display all posts from current user and their friends'
        @posts = Post.all
    end

    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)

        if @post.save
            flash[:success] = "Post created!"
            redirect_to root_url
        else
            flash[:error] = "An error occurred."
            redirect_to root_url
        end 
    end

    def show
        @post = Post.find_by(:id => params[:id])
        @list_of_comments = @post.comments
        @comment = Comment.new
        @current_user_id = current_user.id
    end

    def destroy
        #post can only be destroyed by author
        Post.find_by(:id => params[:id]).destroy
        flash[:success] = "Post destroyed."
        redirect_to root_url
    end

    def like_exists(post_id)
        if Like.find_by(:user_id => current_user.id, :post_id => post_id)
            return true
        else
            return false
        end
    end

    helper_method :like_exists
    
    private

        def post_params
            params.require(:post).permit(:title, :content)
        end
end
