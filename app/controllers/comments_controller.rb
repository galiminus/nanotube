class CommentsController < ApplicationController
  before_action :load_post, only: [:create]
  
  def create
    @comment = Comment.new(params.require(:comment).permit(:body))
    @comment.author = current_user
    @comment.post = @post

    authorize @comment

    if @comment.save
      redirect_to post_path(@post, anchor: "comment-#{@comment.id}")
    else
      render "posts/show"
    end
  end

  protected

  def load_post
    @post = Post.find(params[:post_id])
  end
end
