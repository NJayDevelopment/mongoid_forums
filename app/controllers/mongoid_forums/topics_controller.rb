require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class TopicsController < ApplicationController
    def show
      @topic = current_resource
      @posts = @topic.posts.sort_by {|post| post.created_at}
    end

    def update
    end

    def edit
    end

    def destroy
    end

    private

    def current_resource
      @current_resource ||= Topic.find(params[:id]) if params[:id]
    end
  end
end
