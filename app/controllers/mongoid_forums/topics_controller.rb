require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class TopicsController < ApplicationController
    before_filter :find_forum, :except => [:my_subscriptions, :my_posts, :my_topics]

    def show
      if find_topic
        register_view

        @posts = @topic.posts.order_by([:created_at, :asc])
        @posts = @posts.page(params[:page]).per(MongoidForums.per_page)

        if mongoid_forums_user.present?
          Alert.where(user_id: mongoid_forums_user.id, read: false, subscription_id: Subscription.where(subscribable_id: @topic.id, subscriber_id: mongoid_forums_user.id).first).update_all(:read => true, :ready_at => Time.now)
        end
      end
    end

    def destroy

    end

    def my_subscriptions
        @subscriptions = Subscription.where(:subscriber_id => mongoid_forums_user.id, :subscribable_type => "MongoidForums::Topic", :unsubscribed => false).desc(:updated_at)
        @topics = @subscriptions.page(params[:page]).per(MongoidForums.per_page)
        return @topics.sort_by!{:updated_at}
    end

    def my_posts
        @posts = Post.where(:user_id => mongoid_forums_user.id).by_updated_at.page(params[:page]).per(MongoidForums.per_page)
    end

    def my_topics
        @topics = Topic.where(:user_id => mongoid_forums_user.id).by_most_recent_post.page(params[:page]).per(MongoidForums.per_page)
    end

    def subscribe
      if find_topic
        @topic.subscribe_user(mongoid_forums_user.id)
        flash[:notice] = t("mongoid_forums.topic.subscribed")
        redirect_to topic_url(@topic)
      end
    end

    def unsubscribe
      if find_topic
        @topic.unsubscribe_user(mongoid_forums_user.id)
        flash[:notice] = t("mongoid_forums.topic.unsubscribed")
        redirect_to topic_url(@topic)
      end
    end

    private

    def find_forum
      @forum = Topic.find(params[:id]).forum
    end

    def find_topic
      begin
        scope = @forum.topics # TODO: pending review stuff
        @topic = scope.find(params[:id])
        authorize! :read, @topic
      rescue Mongoid::Errors::DocumentNotFound
        flash.alert = t("mongoid_forums.topic.not_found")
        redirect_to @forum and return
      end
    end

    def register_view
      @topic.register_view_by(mongoid_forums_user)
    end

    def current_resource
      @current_resource ||= Topic.find(params[:id]) if params[:id]
    end

    def topic_params
      params.require(:topic).permit(:name, posts: [:text])
    end
  end
end
