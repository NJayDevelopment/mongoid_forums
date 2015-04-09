require_dependency "mongoid_forums/application_controller"

module MongoidForums
  class ForumsController < ApplicationController
    load_and_authorize_resource :class => 'MongoidForums::Forum', :only => :show
    before_filter :authenticate_mongoid_forums_user, :only => [:create, :new]

    def index
      @categories = Category.asc(:position)
    end

    def show
      @forum = Forum.find(params[:id])
      register_view

      @topics = @forum.topics
      @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(MongoidForums.per_page)
    end

    # Note: This is not an action to make a new Forum!
    # it is to create a new TOPIC within a forum
    def new
      @forum = Forum.find(params[:forum_id])
      authorize! :create_topic, @forum

      @topic = Topic.new
      @topic.forum = @forum.id
    end

    # Note: This is not an action to make a new Forum!
    # it is to create a new TOPIC within a forum
    def create
      @forum = Forum.find(params[:forum_id])
      authorize! :create_topic, @forum

      @topic = Topic.new
      @topic.name = topic_params[:name]
      @topic.user = mongoid_forums_user.id
      @topic.forum = @forum.id
      @post = Post.new
      @post.user = mongoid_forums_user.id
      @post.text = topic_params[:posts][:text]
      @topic.posts << @post

      if @topic.save && @topic.posts.first.save
        flash[:notice] = t("mongoid_forums.topic.created")
        redirect_to @topic
      else
        flash.now.alert = t("mongoid_forums.topic.not_created")
        render :action => "new"
      end
    end

    private

    def register_view
      @forum.register_view_by(mongoid_forums_user)
    end

    def topic_params
      params.require(:topic).permit(:name, :posts => [:text])
    end


  end
end
