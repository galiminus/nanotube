class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_post, except: [:index, :new]
  
  def index
    @posts = policy_scope(Post).page(page).includes(:owner)
    @posts = @posts.where(owner_id: params[:owner_id]) if params[:owner_id]

    @posts =
      case params[:sort]
      when 'likes'
        @posts.order(cached_votes_up: :desc)
      else
        @posts
      end.order(created_at: :desc)
  end

  def new
    @post = Post.new(owner: current_user)

    authorize @post
  end
  
  def show
    authorize @post
  end

  def like
    authorize @post

    @post.liked_by current_user
    redirect_back fallback_location: root_path
  end

  def unlike
    authorize @post
    
    @post.unliked_by current_user
    redirect_back fallback_location: root_path
  end

  protected

  def load_post
    @post = Post.find(params[:id] || params[:post_id])
  end
end
