require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class Admin::ForumsController < BaseController
      before_action :set_forum, only: [:add_group, :remove_group]

      def new
        @forum = Forum.new
      end

      def create
        if @forum = Forum.create(name: params[:forum][:name], category: params[:forum][:category])
          flash[:notice] = "Category created successfully"
          redirect_to @forum
        else
          flash.now.alert = "Category could not be created"
          render :action => "new"
        end
      end

      def edit
      end

      def update
      end

      def destroy
      end

      ### Temporary Methods - Try Not To Cringe Too Much <3 ###
      def add_group
        group = Group.find(params.require(:group_id))
        @forum.moderator_groups << group
        @forum.save
      end

      def remove_group
        group = Group.find(params.require(:group_id))
        @forum.moderator_groups.delete(group)
        @forum.save
      end
      #########################################################

      private

      def category_params
        params.require(:forum).permit(:name, :category)
      end

      def set_forum
        @forum = Forum.find(params[:forum_id])
      end
    end
  end
end
