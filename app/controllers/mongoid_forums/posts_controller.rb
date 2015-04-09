require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class PostsController < ApplicationController
    before_filter :find_topic
    before_filter :authenticate_mongoid_forums_user, except: :show
    before_filter :reject_locked_topic!, only: [:new, :create]

    def new
      authorize! :reply, @topic
      @post = @topic.posts.build
      @post.topic = @topic.id
      if params[:reply_to_id]
        find_reply_to_post

        if @reply_to.id && @reply_to.id == @topic.posts.first.id
          flash[:alert] = t("mongoid_forums.post.not_created_quote_original_post")
          redirect_to @topic
          return
        end
      end

      if @topic.locked
        flash[:alert] = t("mongoid_forums.post.not_created_topic_locked")
        redirect_to @topic
        return
      end

    end

    def create
      authorize! :reply, @topic
      @post = @topic.posts.build(post_params)
      @post.user = mongoid_forums_user

      if @post.save
        @topic.alert_subscribers(mongoid_forums_user.id)
        @topic.forum.increment_posts_count
        flash[:notice] = t("mongoid_forums.post.created")
        redirect_to @topic
      else
        flash.now.alert = t("mongoid_forums.post.not_created")
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
      authorize! :edit_post, @topic.forum
      find_post

      if @post.owner_or_admin?(mongoid_forums_user) && @post.update_attributes(post_params)
        redirect_to @topic, :notice => t('edited', :scope => 'mongoid_forums.post')
      else
        flash.now.alert = t("mongoid_forums.post.not_edited")
        render :action => "edit"
      end
    end

    def destroy
      find_post
      if @topic.posts.first == @post
        flash[:alert] = t("mongoid_forums.post.cannot_delete_first_post")
        redirect_to @topic
        return
      end

      authorize! :destroy_post, @topic.forum

      unless @post.owner_or_admin? mongoid_forums_user
        flash[:alert] = t("mongoid_forums.post.cannot_delete")
        redirect_to @topic and return
      end

      if @post.destroy
        flash[:notice] = t("mongoid_forums.post.deleted")
        redirect_to @topic
      else
        flash[:notice] = t("mongoid_forums.post.cannot_delete")
        redirect_to @topic
      end
    end

    private

    #TODO: Decide if this should be used
    def destroy_successful
      if @post.topic.posts.count == 0
        @post.topic.destroy
        flash[:notice] = "Post was deleted successfully along with it's topic."
        redirect_to @topic.forum
      else
        flash[:notice] = "Post was deleted successfully"
        redirect_to @topic
      end
    end

    def reject_locked_topic!
      if @topic.locked?
        flash.alert = t("mongoid_forums.post.not_created_topic_locked")
        redirect_to @topic and return
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
