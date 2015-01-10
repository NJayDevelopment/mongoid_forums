require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class TopicsController < ApplicationController
    def show
      @topic = Topic.find(params[:id])
      @posts = @topic.posts.sort_by {|post| post.created_at}
    end

    def new
    end

    def create
    end

    def update
    end

    def edit
    end

    def destroy
    end
  end
end
