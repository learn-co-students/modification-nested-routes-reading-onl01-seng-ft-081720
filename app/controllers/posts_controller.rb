class PostsController < ApplicationController

  def index
    if params[:author_id]
      @posts = Author.find(params[:author_id]).posts
    else
      @posts = Post.all
    end
  end

  def show
    if params[:author_id]
      @post = Author.find(params[:author_id]).posts.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end

  def new
    if params[:author_id] && !Author.exists?(params[:author_id]) # if author_id is in params, and that author doesn't exist
      redirect_to authors_path, alert: "Author not found." # redirect to author index with error 
    else # if author does exist
      @post = Post.new(author_id: params[:author_id]) # create post with association to author
    end
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def edit
    if params[:author_id] # if there's an author_id in params
      author = Author.find_by(id: params[:author_id]) # set author by id
      if author.nil? # if the author returns nil/doesn't exist, redirect to author index and show error
        redirect_to authors_path, alert: "Author not found."
      else # if author not nil
        @post = author.posts.find_by(id: params[:id]) # set post by searching post_id through author
        redirect_to author_posts_path(author), alert: "Post not found." if @post.nil? # if author didn't write that post, redirect to author show page, with error
      end
    else # if there is no author_id in params, set post w/o association
      @post = Post.find(params[:id])
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :author_id)
  end
end
