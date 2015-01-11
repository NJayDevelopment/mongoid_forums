require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class PostsController < ApplicationController
    def new
      @topic = Topic.find(params[:topic_id])
      @post = Post.new
      @post.topic = @topic.id
    end

    def create

      @post = Post.new
      @post.text = params[:post][:text]
      @post.topic = params[:topic_id]
      @post.user = current_user.id
      @post.reply_to_id = params[:post][:reply_to_id]
      if @post.save
        flash[:notice] = "Reply created successfully"
        redirect_to @post.topic
      else
        flash.now.alert = "Reply could not be created"
        render :action => "new"
      end
    end

    def show
    end

    def edit
    end

    def update
      @post = current_resource

      if @post.update_attributes(post_params)
        flash[:notice] = "Reply updated successfully"
        redirect_to current_resource.topic
      else
        flash[:notice] = "Reply could not be updated"
        render :action => "edit"
      end
    end

    def destroy
    end

    private

    def current_resource
      @current_resource ||= Post.find(params[:id]) if params[:id]
    end

    def post_params
      params.require(:post).permit(:text, :reply_to_id)
    end


  end
end
