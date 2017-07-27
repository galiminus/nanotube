class UploadController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @post = Post.new({
                  name: params.permit("file.name")["file.name"],
                  content_type: params.permit("file.content_type")["file.content_type"],
                  path: params.permit("file.path")["file.path"],
                  md5: params.permit("file.md5")["file.md5"],
                  size: params.permit("file.size")["file.size"].to_i,
                  title: params.permit("title")["title"],
                  owner: current_user
    })

    if @post.save
      redirect_to posts_path
    else
      render 'posts/new'
    end
  end
end
