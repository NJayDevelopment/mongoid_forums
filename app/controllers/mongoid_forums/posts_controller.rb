require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class PostsController < ApplicationController
    def new
      @topic = Topic.find(params[:topic_id])
      @post = Post.new
      @post.topic = @topic.id
    end

    def create
    end

    def show
    end

    def edit
    end

    def update
    end

    def destroy
    end
  end
end
