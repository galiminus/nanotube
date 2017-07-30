class PostsController < ApplicationController
  before_action :load_post, except: [:index, :new]
  before_action :set_comment, only: [:show]
  before_action :load_tags, only: [:index, :show]
  before_action :load_owner, only: [:index]
  
  def index
    @posts = policy_scope(Post).page(page).includes(:owner)
    @posts = @posts.where(owner_id: params[:owner_id]) if params[:owner_id]
    @posts = @posts.tagged_with(params[:tag], any: true) if params[:tag]
    
    @posts =
      case params[:sort]
      when 'likes'
        @posts.order(cached_votes_up: :desc)
      else
        @posts
      end.order(created_at: :desc)
    
    @refresh_interval = 60
  end

  def new
    @post = Post.new(owner: current_user)

    authorize @post
  end

  def edit
    authorize @post
  end

  def update
    @post.update_attributes(params.require(:post).permit(:title, :description))

    authorize @post
    
    if @post.save
      flash[:notice] = "Your video was successfuly updated"
      redirect_to @post
    else
      render 'post/edit'
    end
  end
  
  def show
    @comments = @post.comments.joins(:author).order(created_at: :asc)
    
    authorize @post
  end

  def destroy
    authorize @post

    if @post.destroy
      flash[:notice] = "Your video was successfuly deleted"
      redirect_to root_path
    else
      flash[:error] = "An unexpected error occured"
      redirect_back fallback_location: root_path
    end
  end
  
  def like
    authorize @post

    @post.liked_by current_user
    redirect_back_with_anchor "post-#{@post.id}"
  end

  def unlike
    authorize @post
    
    @post.unliked_by current_user
    redirect_back_with_anchor "post-#{@post.id}"
  end

  protected

  def load_post
    @post = Post.find(params[:id] || params[:post_id])
  end

  def set_comment
    @comment = Comment.new(author: current_user, post: @post)
  end

  def load_tags
    @tags = ActsAsTaggableOn::Tag.order(taggings_count: :desc).limit(20).pluck(:name)
  end

  def load_owner
    @owner = User.find(params[:owner_id]) if params[:owner_id]
  end
end
