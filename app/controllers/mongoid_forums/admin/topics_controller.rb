module MongoidForums
  module Admin
    class TopicsController < BaseController
      before_filter :find_topic

      def edit
      end

      def update
        @topic.subject  = params[:topic][:subject]
        @topic.pinned   = params[:topic][:pinned]
        @topic.locked   = params[:topic][:locked]
        @topic.hidden   = params[:topic][:hidden]
        @topic.forum_id = params[:topic][:forum_id]
        if @topic.save
          flash[:notice] = t("mongoid_forums.topic.updated")
          redirect_to topic_path(@topic)
        else
          flash.alert = t("mongoid_forums.topic.not_updated")
          render :action => "edit"
        end
      end

      def toggle_hide
        @topic.toggle!(:hidden)
        flash[:notice] = t("mongoid_forums.topic.hidden.#{@topic.hidden?}")
        redirect_to topic_path(@topic)
      end

      def toggle_lock
        @topic.toggle!(:locked)
        flash[:notice] = t("mongoid_forums.topic.locked.#{@topic.locked?}")
        redirect_to topic_path(@topic)
      end

      def toggle_pin
        @topic.toggle!(:pinned)
        flash[:notice] = t("mongoid_forums.topic.pinned.#{@topic.pinned?}")
        redirect_to topic_path(@topic)
      end

      private
        def find_topic
          @topic = Topic.find(params[:format])
        end
    end
  end
end
