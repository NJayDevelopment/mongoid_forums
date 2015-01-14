require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class TopicsController < ApplicationController
    def show
      @topic = current_resource

      @posts = @topic.posts.order_by([:created_at, :asc])
      @posts = @posts.page(params[:page]).per(MongoidForums.per_page)

      if current_user.present?
        Alert.where(:user_id => current_user.id).update_all(:read => true)
      end

    end

    def update
      @topic = current_resource
      if @topic.update_attributes(topic_params)
        flash[:notice] = "Topic updated successfully"
        redirect_to current_resource
      else
        flash[:alert] = "Topic could not be updated"
        render :action => :edit
      end
    end

    def edit
      @topic = current_resource
    end

    def destroy
    end

    def my_subscriptions
        @subscriptions = Subscription.where(:subscriber_id => current_user.id, :subscribable_type => "MongoidForums::Topic", :unsubscribed => false).desc(:updated_at)
        @topics = @subscriptions.page(params[:page]).all.to_a
        return @topics.sort_by!{:updated_at}
    end

    def my_posts
        @posts = Post.where(:user_id => current_user.id).by_updated_at.page(params[:page]).per(20)
    end

    def my_topics
        @topics = Topic.where(:user_id => current_user.id).by_most_recent_post.page(params[:page]).per(20)
    end

    private

    def current_resource
      @current_resource ||= Topic.find(params[:id]) if params[:id]
    end

    def topic_params
      params.require(:topic).permit(:name, posts: [:text])
    end
  end
end
