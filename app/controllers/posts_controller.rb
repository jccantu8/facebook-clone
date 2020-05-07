class PostsController < ApplicationController
    before_action :authenticate_user!

    def index
        @list_of_posts = list_of_posts_from_me_and_my_friends
    end

    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)

        if @post.save
            flash[:success] = "Post created!"
            redirect_to user_post_url(:user_id => current_user.id, :id => @post.id)
        else
            flash[:error] = "An error occurred."
            redirect_to new_user_post_url(:user_id => current_user.id)
        end 
    end

    def show
        @post = Post.find_by(:id => params[:id])
        @list_of_comments = @post.comments
        @comment = Comment.new
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

    def list_of_posts_from_me_and_my_friends
        list_of_friends_ids = current_user.friends.map { |friend| friend.friend_id}

        combined_list = list_of_friends_ids.push(current_user.id)

        return Post.where(user_id: combined_list)
    end

    helper_method :like_exists, :list_of_posts_from_me_and_my_friends
    
    private

        def post_params
            params.require(:post).permit(:title, :content, :picture)
        end
end
