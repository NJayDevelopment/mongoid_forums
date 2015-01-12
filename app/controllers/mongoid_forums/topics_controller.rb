require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class TopicsController < ApplicationController
    def show
      @topic = current_resource
      @posts = @topic.posts.sort_by {|post| post.created_at}
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

    private

    def current_resource
      @current_resource ||= Topic.find(params[:id]) if params[:id]
    end

    def topic_params
      params.require(:topic).permit(:name, posts: [:text])
    end
  end
end
