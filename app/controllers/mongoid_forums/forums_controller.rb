require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class ForumsController < ApplicationController
    def index
      @categories = Category.all
    end

    def show
      @forum = Forum.find(params[:id])
      @topics = @forum.topics.sort_by {|forum| forum.created_at}
    end
  end
end
