require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class PostsController < ApplicationController
    before_filter :find_topic
    before_filter :authenticate_mongoid_forums_user, except: :show

    def new
      authorize! :reply, @topic
      @post = @topic.posts.build
      @post.topic = @topic.id
      if params[:reply_to_id]
        find_reply_to_post
      end
    end

    def create
      authorize! :reply, @topic
      @post = @topic.posts.build(post_params)
      @post.user = mongoid_forums_user

      if @post.reply_to_id && @post.reply_to_id == @topic.posts.first.id
        flash[:alert] = "You may not quote the original post"
        redirect_to @topic
        return
      end

      if @topic.locked
        flash[:alert] = "You may not post on a locked topic"
        redirect_to @topic
        return
      end

      if @post.save
        @topic.alert_subscribers(mongoid_forums_user.id)
        @topic.forum.increment_posts_count
        flash[:notice] = "Reply created successfully"
        redirect_to @topic
      else
        flash.now.alert = "Reply could not be created"
        render :action => "new"
      end
    end

    def show
    end

    def edit
      find_post
      authorize! :edit_post, @topic.forum
    end

    def update
      if @topic.locked?
        flash.alert = "You may not update a post on a locked topic!"
        redirect_to [@topic] and return
      end

      find_post
      authorize! :edit_post, @topic.forum

      if @post.update_attributes(post_params)
        flash[:notice] = "Reply updated successfully"
        redirect_to @topic
      else
        flash[:notice] = "Reply could not be updated"
        render :action => "edit"
      end
    end

    def destroy
      find_post
      if @topic.posts.first == @post
        flash[:alert] = "You may not delete the first post!"
        redirect_to @topic
        return
      end

      authorize! :destroy_post, @topic.forum #TODO: Check is user is owner of post

      if @post.destroy
        flash[:notice] = "Post deleted successfully"
        redirect_to @topic
      else
        flash[:notice] = "Post could not be deleted"
        redirect_to @topic
      end
    end

    private

    def destroy_successful
      if @post.topic.posts.count == 0
        @post.topic.destroy
        flash[:notice] = "Post was deleted successfully along with it's topic."
        redirect_to [@topic.forum]
      else
        flash[:notice] = "Post was deleted successfully"
        redirect_to [@topic.forum, @topic]
      end
    end

    def find_post
      @post = current_resource
    end

    def find_topic
      @topic = Topic.find params[:topic_id]
    end

    def current_resource
      @current_resource ||= Post.find(params[:id]) if params[:id]
    end

    def post_params
      params.require(:post).permit(:text, :reply_to_id)
    end

    def find_reply_to_post
      @reply_to = @topic.posts.find(params[:reply_to_id])
    end

  end
end
