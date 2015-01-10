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

    # Note: This is not an action to make a new Forum!
    # it is to create a new TOPIC within a forum
    def new
      @forum = Forum.find(params[:forum_id])
      @topic = Topic.new
      @topic.forum = @forum.id

      puts "dkjhfkshfkjsdhflkdshfklsjdhkflhjdslkjhfaklsdjhflkasdjhflkjasdhflkhasdoiufhpawh4oiy348yiHOHFOSDHLKFJHSDKLJFHSKLDJFHSLDKFHJLSKDFJHSLDKFJHSDLKFHJDSKLFHJSLKD"
    end

    def create
      @forum = Forum.find(params[:forum_id])
      @topic = Topic.new
      @topic.name = topic_params[:name]
      @topic.user = current_user.id
      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      puts @topic.attributes
      puts @forum.name

      if @topic.save && @topic.posts.first.save
        flash[:notice] = "Topic created successfully"
        redirect_to @topic
      else
        flash.now.alert = "Topic could not be created"
        render :action => "new"
      end
    end

  private

  def topic_params
    params.require(:topic).permit(:name)
  end



  end
end
